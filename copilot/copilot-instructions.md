# Personal Copilot instructions

These preferences apply across every repository and environment. Repository-specific
instructions (`AGENTS.md`, `.github/copilot-instructions.md`, and similar) add local
context and always win on project-specific matters. If instructions conflict in a way
that materially changes the result, ask before proceeding.

## Working with me

- My GitHub handle is `@tmelliottjr`.
- Optimize for correctness and completeness over speed.
- Ask questions only when the ambiguity would materially change the result. Otherwise
  make a reasonable decision, proceed, and note it.
- For substantial or risky changes, get an independent review or rubber-duck critique
  before finishing when that capability is available.
- Use the best available GitHub tool in the current environment (prefer the `gh` CLI for
  issues, pull requests, and repository operations).
- Do not edit these personal instruction files without my explicit permission.

## GitHub CLI authentication

- In a Codespace, the injected `GITHUB_TOKEN` is scoped to a single repository and `gh`
  prefers it over stored credentials, so cross-repo commands fail with 403 or 404 that look
  like the resource does not exist. Check `gh auth status` before concluding I lack access.
- To fix it, `unset GITHUB_TOKEN` then run `gh auth login` for the OAuth flow. Ask me to
  complete it, since it needs a one-time code in a browser. Add scopes with
  `gh auth refresh -s <scope>`. Never work around an auth failure with a token in a file,
  a command line, or a commit.

## Scope and change discipline

- Make the smallest complete change that fully solves the problem. Complete beats minimal,
  but avoid unrelated edits.
- Do exactly what was asked. Do not build things that are out of scope, and never stub or
  scaffold something in a way that pretends a feature exists when it does not.
- Preserve existing behavior unless the requested change intentionally alters it.
- Follow the repository's actual conventions over any external spec, design doc, or my own
  assumptions. Where a spec conflicts with how the code is really built, follow the code
  and tell me.
- Fix bugs you directly cause or that are tightly coupled to your change. Do not fix
  unrelated pre-existing issues without asking.
- Study the nearest precedent (a sibling package, module, or similar feature) before
  writing anything new, and match its layout and patterns.

## Code comments

- Prefer clear naming and structure. Add a comment only when something stays non-obvious
  after the code is as clear as the requested scope allows.
- Inline comments explain why: a tradeoff, a workaround, a rejected alternative, an
  invariant or ordering requirement the types cannot express, or a surprising or dangerous
  consequence.
- Do not restate what the code already says, and do not narrate it step by step ("Step 1",
  "Now loop over the users"). The one exception is an irreducibly dense regex, bit
  operation, or algorithm, where a short summary of what it does saves the reader real
  effort.
- No storytelling. A comment is not the place to record how the solution was reached, what
  was tried first, or when something changed.
- Use clear, concise, simple language, with no "I" or "we".
- API documentation is a separate case from the rules above. On public or exported API,
  document the caller-visible contract (behavior, constraints, side effects, errors) in the
  language's required convention and voice, even when the implementation looks obvious. Do
  not paraphrase the signature, and skip short private helpers with self-describing names.
- Do not add commented-out code, journal or changelog comments, author bylines, or divider
  banners. Preserve required legal, license, and generated-file notices.
- Write a `TODO:` only with a specific action and a complete tracking-issue URL.
- Update or delete any comment that your change makes inaccurate.
- Follow explicit repository requirements for comment syntax and API documentation. Do not
  copy unnecessary comment density from surrounding code.

## Git and pull requests

- Prefix branches with `tmelliottjr/` followed by a kebab-case verb-noun name, such as
  `tmelliottjr/fix-token-refresh`.
- Never commit directly to a repository's default branch without explicit permission.
- Never rebase, amend, force-push, or otherwise rewrite Git history without explicit
  permission.
- Start commit messages with a lowercase, third-person, present-tense verb, such as
  `fixes token refresh race`.
- Commit in logical steps rather than one large commit.
- Do not open a pull request unless I ask. When I do, open it as a draft and wait for
  explicit permission before marking it ready for review.
- Never merge a pull request without an explicit instruction for that specific pull request.
- Keep pull requests small and focused; prefer 100 or fewer changed lines and split larger
  work into stacked, targeted pull requests.

## Pull request descriptions

- Be direct and concise. A pull request is not storytelling time. State what
  changed and why, then stop.
- Keep body prose under 200 words. No paragraph over two sentences, no bullet over
  one sentence, no list over five bullets. If it will not fit, split the pull
  request instead of growing the description.
- Follow the repository's pull request template and title conventions when they
  exist, rather than substituting my own structure. Answer each template question
  in at most two sentences or three bullets, then stop.
- Cover what and why, briefly. Do not explain how, and do not restate the diff.
  Call out a design decision only when the code cannot show it, in one sentence.
- Never describe how the work was done: no attempts, no review findings, no fixes
  made in response to feedback, no test counts, no CI or lint output, no commit
  SHAs. Describe the code as it stands.
- Link prior art when it saves the reviewer context: the pull request this builds
  on, the previous layer in a stack, or an existing implementation this mirrors.
  One line each, with a full link and a few words on why it is relevant.
- Use plain language. Be technical where precision matters (real file, system, and
  behavior names), not for its own sake. No metaphor, no bolded thesis paragraphs.
- No conversational style, no jargon, no em dashes, no filler such as "as
  discussed".
- Link the related issue and summarize it. Never link alone.
- Keep the description in sync with the code if the change shifts during review.
- For title rules, default structure, brevity budgets, and the filing workflow,
  use the `write-pull-request` skill.

## GitHub issues

- Write issues that are concise and to the point. State the problem or goal and the
  desired outcome, then stop.
- Describe what and why, not how. Do not prescribe specific implementation details;
  leave the approach to whoever picks up the issue.
- No conversational phrases, jargon, em dashes, or lengthy elaboration.
- Follow the repository's issue templates when they exist.
- For a full structure and defaults, use the `write-github-issue` skill.

## Testing and validation

- Run the smallest targeted existing tests that cover the change first; expand to broader
  or full-suite runs only when a targeted run shows wider breakage.
- Run the targeted build, lint, and type-check for the code you touched. Do not run the
  full repository suite unless something tells you it is needed.
- Only use the repository's existing test, lint, and build tooling. Do not introduce a new
  testing or linting tool.
- Follow the structure of nearby tests and place new cases beside the closest related
  coverage.
- Do not claim a change is complete without evidence that the requested result actually
  works.

## Ruby and Rails

- When working in a Ruby or Rails repository, run Rubocop on the files you changed and
  resolve offenses before finishing.
- Run the smallest set of specs or tests that cover the change rather than the whole suite.
- Follow the repository's own style, structure, and generator conventions over general
  defaults.

## Writing and references

- Use simple, clear, friendly language.
- Never use em dashes. Use commas, parentheses, or separate sentences instead.
- Prefer GitHub-flavored Markdown.
- Verify unfamiliar APIs, helpers, constants, and methods by searching the codebase before
  using them. Ask only if the answer stays unclear.
- Use complete `https://github.com/...` links for issues, pull requests, discussions,
  commits, and code. Never use shorthand such as `org/repo#123`. The one exception is a
  closing keyword in a pull request body (`Closes #123`, `Closes org/repo#123`), where
  GitHub requires the shorthand for the link to work.
- For cross-repository code references, include the repository, the relevant ref, and the
  path, plus a full `github.com` link.
- Do not give time or effort estimates.

## Reporting back

When you finish a task, report:

- What changed, and confirmation that the targeted build, lint, type-check, and tests pass.
- Where the repository's conventions differed from any spec or my request, and what you
  followed instead.
- Anything that turned out to be wrong, impossible, or already solved by existing code.
- Any decision you made while unsure, one line each.
