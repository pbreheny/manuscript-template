# Manuscript template

## Organization

cache would live separate; see other repo (link)

## Installing LaTeX

The easiest, simplest way to get LaTeX up and running is with [TinyTeX](https://github.com/rstudio/tinytex-releases) (via R):

``` R
install.packages("tinytex")
tinytex::install_tinytex()
```

Follow the prompts and you're done, that's it.

* TinyTeX is a lightweight version of [TeX Live](https://tug.org/texlive/). If you feel comfortable doing so, go ahead and install the full TeX Live.
* I recommend against alternative distributions such as MiKTeX. They are not inherently bad, but they are much harder to set up, students often run into problems, and I have no ability or interest in helping you configure MiKTeX.

At this point, you can check to see that you have a working LaTeX installation by running this from a terminal:

``` bash
latexmk --xelatex -output-directory=build my-paper.tex
```

## LaTeX Workshop

I recommend using VS Code with the LaTeX Workshop extension as an editor. It is easy to set up and offers many attractive features (including but not limited to):

* Side by side source code and PDF product
* Automatic rebuilding every time you save
* Can work on documents collaboratively with Live Share

##### Install

1. Download and install [VS Code](https://code.visualstudio.com/download)
2. From within VS Code, install the following extensions:
    a. LaTeX Workshop
    b. Code Spell Checker (optional but recommended)

##### Setup

If you've forked or cloned this repo, it's already set up --- you can skip this section.

If you're still reading this section, that means you want to know more details. This repository contains a file `.vscode/settings.json`, that already contains the configuration settings I recommend. However, if you want to set this up globally for your VS Code installation, open the Command Palette (`Ctrl+P`), go to Open User Settings, then search for the following:

* `latex-workshop.latex.outDir`: Set this to `build`. Compiling a LaTeX document produces a large number of extraneous files. You do not want them cluttering up your main directory, and you do not want to version control them (`build` is already included in the `.gitignore` file in this repository.
* `latex-workshop.latex.recipe.default`: Set this to `latexmk (xelatex)`. This one isn't critically important, since `latexmk` is already the default in LaTeX Workshop. However, I do think `xelatex` is a better default engine, since it handles characters like á, which often show up in citations.

If you really want to know more about this, you can check out the [LaTeX Workshop wiki](https://github.com/james-yu/latex-workshop/wiki/compile).

##### Workflow

To render your manuscript (from within VS Code), click on the little green triangle in the top right (or `Ctrl+Alt+b`). If this is the first time you're running it, this will create a `build` folder and inside it, `my-paper.pdf`. Right click on that file and select "Open to the side".

From now on, every time you save the file (`Ctrl+s`), the PDF will automatically update.

Note also that if you `Ctrl+` click on a spot in the PDF, VS Code will take you to the corresponding location in the source code.

## JabRef

Everyone should maintain a personal database of all the articles they are familiar with and might wish to cite. I highly recommend [JabRef](https://www.jabref.org/) for this purpose.

Furthermore, even though this feels heavy-handed, you must use the standardized form `Hastie2009` (first author plus year) for all reference keys (JabRef does this automatically if you select "Generate citation key"). Any other approach is inherently antagonistic to collaboration --- none of your co-authors will have any idea what your citations mean or what keys to use.
