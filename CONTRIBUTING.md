# Guidelines for contributing

## Reporting bugs

Before reporting a bug, try to search for a similar problem in the *Issues* section on GitHub. Clear the search bar to include closed issues in the search and type your phrase. When you click on *New issue*, several templates will be displayed — please pick *Bug Report*. Carefully fill out the template and submit the issue.

## Requesting features

If you have an idea for improvement, you can submit your proposal in the *Issues* section on GitHub. When you click on *New issue*, several templates will be displayed — please pick *Feature Request*. Carefully fill out the template and submit the issue.

## Local development environment setup

Please follow instructions specified in the [README](README.md#installation) file and you are good to code!

## Ephemeral development environment

You are more then welcome to contribute to our codebase from the cloud!  
We set up an ephemeral [Gitpod](https://www.gitpod.io) environment for all the developers who prefer coding from a remote server.

Just click on this cool button below:  
[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/AngryMaciek/warlock)

See more information on how to start up a _Gitpod_ environment dedicated to a specific remote branch [here](https://www.gitpod.io/docs/introduction/learn-gitpod/context-url#branch-and-commit-contexts), specific issue [here](https://www.gitpod.io/docs/introduction/learn-gitpod/context-url#issue-context) and a specific pull request [here](https://www.gitpod.io/docs/introduction/learn-gitpod/context-url#pullmerge-request-context).

However, please remember that such luxury is limitted:
> Gitpod offers a free plan for new users which includes 50 hours of standard workspace usage.
> If you need more hours, you can upgrade to one of the paid plans in your personal settings.

## Branch naming convention

You can read about git branching [under this address](https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging). The branch names should follow the convention specified below:

```
<type>/<issue id>/<short description>
```

where

- **type** is one of the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)' types, i.e. `feat`, `ci`, `docs`, `fix`, `refactor`, `test`, `chore`, etc.
- **issue id** is the id of the issue which will be fixed by this PR.
- **short description** is ~25 characters long at max and is hyphenated.

Examples:

```
chore/6/gitignore
docs/22/contributing-instructions
refactor/8/initial-project-structure
```

## Commit messages

In an effort to increase consistency, simplify maintenance and enable automated
change logs, we would like to kindly ask you to write _semantic commit
messages_, as described in the Conventional Commits
specification (link above).

The general structure of _Conventional Commits_ is as follows:

```console
<type>[optional scope]: <description>

[optional body]

[optional footer]
```

## Merging the pull request

A pull request can only be merged after it completed all of the checks performed by CI.  
After a manual review by one of the maintainers, it can be merged into `master`.
