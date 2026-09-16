# homebrew-core's tmux + a patch so every redraw is wrapped in synchronized
# output (DECSET 2026). Stock tmux moves the visible cursor outside sync blocks,
# which ghostty's cursor-trail shader renders as the cursor jumping to wherever
# nvim is redrawing (line numbers, LSP progress, ...).
#
# version/url/sha256/deps are read from homebrew-core at load time, so when core
# bumps tmux this formula becomes outdated too and `brew upgrade` rebuilds it
# with the patch. If the patch stops applying, the build fails and the old
# patched tmux stays installed.
#
# Installed into the local/tmux tap by run_onchange_before_05-tmux-tap.sh.tmpl.
class Tmux < Formula
  CORE = Formulary.factory("homebrew/core/tmux")

  desc "Terminal multiplexer (synchronized-output patch)"
  homepage "https://tmux.github.io/"
  url CORE.stable.url
  sha256 CORE.stable.checksum.hexdigest
  version CORE.version.to_s
  revision CORE.revision
  license "ISC"

  CORE.deps.each do |dep|
    dep.tags.empty? ? depends_on(dep.name) : depends_on(dep.name => dep.tags)
  end

  patch :DATA

  # mirrors homebrew-core's install
  def install
    args = %W[
      --enable-sixel
      --sysconfdir=#{etc}
      --enable-utf8proc
    ]
    args << "--with-TERM=screen-256color" if OS.mac? && MacOS.version < :sonoma

    system "./configure", *args, *std_configure_args
    system "make", "install"

    pkgshare.install "example_tmux.conf"
  end

  test do
    system bin/"tmux", "-V"
  end
end

__END__
--- a/screen-write.c
+++ b/screen-write.c
@@ -256,12 +256,13 @@
 
 	if (~ctx->flags & SCREEN_WRITE_SYNC) {
 		/*
-		 * For the active pane or for an overlay (no pane), we want to
-		 * only use synchronized updates if requested (commands that
-		 * move the cursor); for other panes, always use it, since the
-		 * cursor will have to move.
+		 * For an overlay (no pane), we want to only use synchronized
+		 * updates if requested (commands that move the cursor); for
+		 * panes, always use it, including the active pane: drawing
+		 * cells moves the cursor while it is still visible, which
+		 * terminals that animate the cursor render as a jump.
 		 */
-		if (ctx->wp != NULL && ctx->wp != ctx->wp->window->active)
+		if (ctx->wp != NULL)
 			ttyctx->flags |= TTY_CTX_SYNC;
 		else {
 			if (ctx->wp == NULL)
--- a/server-client.c
+++ b/server-client.c
@@ -1787,6 +1787,17 @@
 	if (log_get_level() != 0) {
 		log_debug("%s: client %s mode %s", __func__, c->name,
 		    screen_mode_to_string(mode));
+	}
+
+	/*
+	 * If the pane is in the middle of a synchronized update its cursor
+	 * could be anywhere, so leave the terminal alone (and keep any
+	 * synchronized update open) until the pane finishes and is redrawn.
+	 */
+	if (c->overlay_draw == NULL && wp != NULL && s == wp->screen &&
+	    (mode & MODE_SYNC)) {
+		tty->flags |= flags;
+		return;
 	}
 
 	/* Reset region and margin. */
