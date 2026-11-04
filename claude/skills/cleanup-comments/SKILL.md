---
name: cleanup-comments
description: Clean up docstrings and code comments Claude wrote during this session. Rewrites them to sound natural and deletes ones that just restate the code. Use when the user asks to clean up, polish, or humanize comments or docstrings at the end of a session.
---

Find every docstring and code comment you added or changed in this session
(use `git diff` to confirm). Only touch ones you wrote. Then, for each one:

1. Evaluate whether it earns its place. Delete it if it only restates what
   the code already makes clear, such as a comment that says "increment the
   counter" above `counter += 1`, or a docstring that repeats the function
   name and signature in sentence form. Keep it if it explains why something
   is done, a non-obvious constraint, a gotcha, or behavior a reader couldn't
   easily infer from the implementation.
2. If you keep it, rewrite it so it reads the way a thoughtful developer
   would write it by hand:
   - Plain, conversational wording; no filler like "This function is
     responsible for"
   - Short, and focused on what matters
   - Preserve required structure (param/return sections, doctest examples)

When in doubt about whether a comment is obvious, lean toward deleting it,
but keep public API docstrings that a user of the function would need.

Don't change code or signatures, and don't touch comments or docstrings you
didn't write. Edit the files directly, then give me a short summary: how many
you rewrote, how many you deleted, and anything you left because you weren't
sure.
