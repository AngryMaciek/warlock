# Guidelines for contributing

## General workflow

We are using [Git][res-git], [GitHub][res-github] and [GitHub Flow][res-git-flow].

> **Note:** If you are a **beginner** and do not have a lot of experience with
> this sort of workflow, please do not feel overwhelmed. We will guide you
> through the process until you feel comfortable using it. And do not worry
> about mistakes either - everybody does them. Often! Our project layout makes
> it very very hard for anyone to cause irreversible harm, so relax, try things
> out, take your time and enjoy the work! :)

## Issue tracker

Please use project's GitHub [issue tracker][res-issue-tracker] to:

- find issues to work on
- report bugs
- propose features
- discuss future directions

## Submitting issues

Please choose a template when submitting an issue: choose the [Bug report
template][res-bug-report] only when reporting bugs; for all other issues,
choose the [Feature request template][res-feature-request]. Please follow the
instructions in the template.

You do not need to worry about adding labels or milestones for an issue, the
project maintainers will do that for you. However, it is important that all
issues are written concisely, yet with enough detail and with proper
references (links, screenshots, etc.) to allow other contributors to start
working on them. For bug reports, it is essential that they include
reproducible examples.

Please **do not** use the issue tracker to ask usage questions, installation
problems etc., unless they appear to be bugs.

## Ephemeral development environment

You are more then welcome to contribute to our codebase from the cloud! We set up an ephemeral [Gitpod](https://www.gitpod.io) environment for all the developers who prefer coding from a remote server.

Just click on this cool button below:  
[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/AngryMaciek/warlock)

See more information on how to start up a _Gitpod_ environment dedicated to a specific remote branch [here](https://www.gitpod.io/docs/introduction/learn-gitpod/context-url#branch-and-commit-contexts), specific issue [here](https://www.gitpod.io/docs/introduction/learn-gitpod/context-url#issue-context) and a specific pull request [here](https://www.gitpod.io/docs/introduction/learn-gitpod/context-url#pullmerge-request-context).

However, please remember that such luxury is limitted:
> Gitpod offers a free plan for new users which includes 50 hours of standard workspace usage.
>If you need more hours, you can upgrade to one of the paid plans in your personal settings.

## Code style

To make it easier for everyone to maintain, read and contribute to the code, as well as to ensure that the code base is robust and of high quality, we would kindly ask you to stick to the used code, docstring and commenting style within a project to maintain consistency

## Commit messages

In an effort to increase consistency, simplify maintenance and enable automated
change logs, we would like to kindly ask you to write _semantic commit
messages_, as described in the [Conventional Commits
specification][res-conv-commits].

The general structure of _Conventional Commits_ is as follows:

```console
<type>[optional scope]: <description>

[optional body]

[optional footer]
```

Depending on the changes, please use one of the following **type** prefixes:

| Type | Description |
| --- | --- |
| build | The build type (formerly known as chore) is used to identify development changes related to the build system (involving scripts, configurations or tools) and package dependencies.  |
| ci | The ci type is used to identify development changes related to the continuous integration and deployment system - involving scripts, configurations or tools. |
| docs | The docs type is used to identify documentation changes related to the project - whether intended externally for the end users (in case of a library) or internally for the developers. |
| feat | The feat type is used to identify production changes related to new backward-compatible abilities or functionality. |
| fix | The fix type is used to identify production changes related to backward-compatible bug fixes. |
| perf | The perf type is used to identify production changes related to backward-compatible performance improvements. |
| refactor | The refactor type is used to identify development changes related to modifying the codebase, which neither adds a feature nor fixes a bug - such as removing redundant code, simplifying the code, renaming variables, etc. |
| revert | For commits that revert one or more previous commits. |
| style | The style type is used to identify development changes related to styling the codebase, regardless of the meaning - such as indentations, semi-colons, quotes, trailing commas and so on. |
| test | The test type is used to identify development changes related to tests - such as refactoring existing tests or adding new tests. |

In order to ensure that the format of your commit messages adheres to the
Conventional Commits specification and the defined type vocabulary, you can
use the [dedicated linter][res-conv-commits-lint]. More information about
_Conventional Commits_ can also be found in this [blog
post][res-conv-commits-blog].

## Merging your code

Here is a check list that you can follow to make sure that code merges
happen smoothly:

1. [Open an issue](#submitting-issues) first to give other contributors a
   chance to discuss the proposed changes (alternatively: assign yourself
   to one of the existing issues)
2. Clone the repository, create a feature branch off of the default branch
   (never commit changes to protected branches directly) and implement your code changes
3. Ensure that your coding style is in line with the
   [guidelines](#code-style) described above
4. Ensure that all the checks configured in the [continuous integration][res-ci-cd] (CI) pipeline pass without
   issues
5. If necessary, clean up excessive commits with `git rebase`; cherry-pick and
   merge commits as you see fit; use concise and descriptive commit messages
6. Push your clean, tested and documented feature branch to the remote; make
   sure the CI pipeline passes
7. Issue a pull request against the default branch; follow the instructions in
   the [template][res-pull-request]; importantly, describe your changes in
   detail, yet with concise language, and do not forget to indicate which
   issue(s) the code changes resolve or refer to; assign a project maintainer
   to review your changes

[res-git]: <https://git-scm.com/>
[res-github]: <https://github.com>
[res-git-flow]: <https://githubflow.github.io/>
[res-issue-tracker]: <https://github.com/AngryMaciek/warlock/issues>
[res-bug-report]: .github/ISSUE_TEMPLATE/bug_report.md
[res-feature-request]: .github/ISSUE_TEMPLATE/feature_request.md
[res-py]: <https://www.python.org/>
[res-sh-shellcheck]: <https://github.com/koalaman/shellcheck>
[res-py-flake8]: <https://gitlab.com/pycqa/flake8>
[res-py-pytest]: <https://docs.pytest.org/en/latest/>
[res-py-coverage]: <https://pypi.org/project/coverage/>
[res-conv-commits]: <https://www.conventionalcommits.org/en/v1.0.0-beta.2/#specification>
[res-conv-commits-lint]: <https://github.com/conventional-changelog/commitlint>
[res-conv-commits-blog]: <https://nitayneeman.com/posts/understanding-semantic-commit-messages-using-git-and-angular/>
[res-ci-cd]: <https://en.wikipedia.org/wiki/Continuous_integration>
[res-pull-request]: PULL_REQUEST_TEMPLATE.md
