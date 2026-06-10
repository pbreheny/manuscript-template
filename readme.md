# Manuscript template

## Organization

* `template`: This directory contains the template. The basic idea is that you can copy this folder over to a new location, change its name, and begin writing. The infrastructure is all set up.
  * `template/my-paper.tex`: This is a wrapper file that controls the appearance and layout of the paper.
  * `template/main.tex`: This contains the actual scientific content of the paper. It is almost always beneficial to separate layout from content when you write a paper --- different journals have different formatting requirements, and you may have to submit the manuscript multiple times, submit to arXiv, etc. You want to divorce those changes from content changes.
  * `Snakefile`: This describes how all the outputs are built and how all the files relate to one another. It describes how to build each figure and table that the manuscript will require, as well as how to build various versions of the manuscript (e.g., the version you submit to a journal and the version you submit to arXiv).
* `style-guide.pdf`: This describes a collection of "do"s and "don't"s with respect to writing and using LaTeX, compiled from years of observing students making the same mistakes.
* `cache`: This represents results from a simulation study that the manuscript will use. It would typically live in some other directory outside the manuscript. See the [research template](https://github.com/pbreheny/reproducible-template/) for more on the integration between manuscripts and research.

## Installing LaTeX

The easiest, simplest way to get LaTeX up and running is with [TinyTeX](https://github.com/rstudio/tinytex-releases) (via R):

``` R
install.packages("tinytex")
tinytex::install_tinytex()
```

Follow the prompts and you're done, that's it.

* TinyTeX is a lightweight version of [TeX Live](https://tug.org/texlive/). If you feel comfortable doing so, go ahead and install the full TeX Live.
* I recommend against alternative distributions such as MiKTeX. They are not inherently bad, but they are much harder to set up, students often run into problems, and I have no ability or interest in helping you configure MiKTeX.

At this point, you can check to see that you have a working LaTeX installation by going into the template and running this from a terminal:

``` bash
latexmk --xelatex -output-directory=build my-paper.tex
```

## LaTeX Workshop

I recommend using VS Code with the LaTeX Workshop extension as an editor. It is easy to set up and offers many attractive features (including but not limited to):

* Side by side source code and PDF product
* Automatic rebuilding every time you save
* Automatic completion of LaTeX commands and syntax checking
* Can work on documents collaboratively with Live Share

##### Install

1. Download and install [VS Code](https://code.visualstudio.com/download)
2. From within VS Code, install the following extensions:
    a. LaTeX Workshop
    b. Code Spell Checker (optional but recommended)

##### Setup

If you're using the template, it's already set up --- you can skip this section.

If you're still reading this section, that means you want to know more details. The template contains a file `.vscode/settings.json`, that already contains the configuration settings I recommend. However, if you want to set this up globally for your VS Code installation, open the Command Palette (`Ctrl+P`), go to Open User Settings, then search for the following:

* `latex-workshop.latex.outDir`: Set this to `build`. Compiling a LaTeX document produces a large number of extraneous files. You do not want them cluttering up your main directory, and you do not want to version control them (`build` is already included in the `.gitignore` file in this repository.
* `latex-workshop.latex.recipe.default`: Set this to `latexmk (xelatex)`. This one isn't critically important, since `latexmk` is already the default in LaTeX Workshop. However, I do think `xelatex` is a better default engine, since it handles characters like á, which often show up in citations, and allows you to use unicode math fonts.

If you really want to know more about this, you can check out the [LaTeX Workshop wiki](https://github.com/james-yu/latex-workshop/wiki/compile).

##### Workflow

To render your manuscript (from within VS Code), click on the little green triangle in the top right (or `Ctrl+Alt+b`). If this is the first time you're running it, this will create a `build` folder and inside it, `my-paper.pdf`. Right click on that file and select "Open to the side".

From now on, every time you save the file (`Ctrl+s`), the PDF will automatically update.

Note also that if you `Ctrl+` click on a spot in the PDF, VS Code will take you to the corresponding location in the source code.

## JabRef

Everyone should maintain a personal database of all the articles they are familiar with and might wish to cite. I highly recommend [JabRef](https://www.jabref.org/) for this purpose.

Furthermore, I **strongly** recommend using the standardized form `Hastie2009` (first author plus year) for all reference keys (JabRef does this automatically if you select "Generate citation key"). Any other approach is inherently annoying to all of your coauthors, none of whom will have any idea what your citations mean or what keys to use.

## Snakemake

[Snakemake](https://snakemake.readthedocs.io) is not inherently a part of writing LaTeX documents, but if you're going to have external code that creates figures and tables, and the output of that code is needed for the LaTeX document, Snakemake provides a convenient way to describe those dependencies. You don't really need to know anything about Python or how Snakemake works in order to use it.

Basically, you just go to the `template` directory, run

``` bash
snakemake
```

And it will build all the necessary figures and tables, compile the document, compile the supplement, create a version for arXiv, and compile that too.

Snakemake is a Python package. If you already have a preferred Python environment manager, install it there. Otherwise, install it with `pip`:

```bash
python3 -m pip install snakemake
```

or if you use `uv`:

```bash
uv pip install snakemake
```

After installation, verify that Snakemake is available by running:

```bash
snakemake --version
```
