# Manuscript template

## Organization

* `style-guide.pdf`: This describes a collection of "do"s and "don't"s with respect to writing and using LaTeX, compiled from years of observing students making the same mistakes.
* `cache`: This represents results from a simulation study that the manuscript will use. It would typically live in some other directory outside the manuscript. See the [research template](https://github.com/pbreheny/reproducible-template/) for more on the integration between manuscripts and research.
* `template`: This directory contains the template. The basic idea is that you can copy this folder over to a new location, change its name, and begin writing. The infrastructure is all set up.
  * `template/my-paper.tex`: This is a wrapper file that defines the document structure.
  * `template/preamble.tex`: This loads packages that control the appearance and layout of the paper.
  * `template/math-traditional.tex`: Defines mathematical symbols and macros; this is copied from the [pb-latex repo](https://github.com/pbreheny/pb-latex/).
  * `template/main.tex`: This contains the actual scientific content of the paper.
  * `template/abstract.tex`: The abstract.
  * `template/Snakefile`: You can ignore this if you want, but see the section on Snakemake below.
  * `template/smallcap.bst`: A bibliography style file from [pb-latex repo](https://github.com/pbreheny/pb-latex/).

I strongly recommend having separate `.tex` files so that you can separate *layout* from *content* when you write a paper. Different journals have different formatting requirements, and you may have to submit the manuscript multiple times, you may want to submit to arXiv, etc. These involve changing the format, but the content needs to the same across these versions. You don't want to rewrite a paragraph, but then also have to go rewrite the same paragraph in the arXiv version, etc.

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

I highly recommend using VS Code with the LaTeX Workshop extension as an editor. It is easy to set up and offers many attractive features (including but not limited to):

* Side by side source code and PDF product
* Automatic rebuilding every time you save
* Automatic completion of LaTeX commands and syntax checking
* Can work on documents collaboratively with Live Share

##### Install

1. Download and install [VS Code](https://code.visualstudio.com/download)
2. From within VS Code, install the following extensions:
   * LaTeX Workshop
   * Code Spell Checker (optional but recommended)

##### Setup

If you're using the template, it's already set up — you can skip this section.

If you want to know the details, look at `template/.vscode/settings.json`: this  contains the configuration settings I recommend (although as with any configuration, you may have different preferences).

##### Workflow

To render your manuscript (from within VS Code), click on the little green triangle in the top right (or `Ctrl+Alt+b`). If this is the first time you're running it, this will create a `my-paper` folder and inside it, `my-paper.pdf`. Right click on that file and select "Open to the side".

From now on, every time you save the file (`Ctrl+s`), the PDF will automatically update.

Note also that if you `Ctrl+` click on a spot in the PDF, VS Code will take you to the corresponding location in the source code.

---

Here, I list two additional useful tools. Neither is essential — you can write manuscripts and compile LaTeX documents without them. However, I highly recommend learning how to use them, as they will both prove immensely valuable in the figure.

## JabRef

Everyone should maintain a personal database of all the articles they are familiar with and might wish to cite. I highly recommend [JabRef](https://www.jabref.org/) for this purpose.

Furthermore, I strongly recommend using the standardized form `Hastie2009` (first author plus year) for all reference keys (JabRef does this automatically if you select "Generate citation key"). Any other approach will annoy your coauthors, who will not have any idea what your citations mean or what keys to use.

## Snakemake

When using LaTeX workshop, every time you save, the document is rebuilt — the output always matches the input. This is not true for the figures and tables, however. If you make a change to the code that generates figure 1, there is no guarantee that this is reflected in the manuscript. Furthermore, where did `figure1.pdf` even come from? What code created it?

To address all of these issues, use [Snakemake](https://snakemake.readthedocs.io). This provides a structured way to map out all the dependencies, all the inputs and outputs that your manuscript depends on (e.g., the manuscript depends on `figure1.pdf`, and `figure1.pdf` is created by running `figure1.R`).

Snakemake is a Python package, although you don't need to know Python in order to use it. If you already have a preferred Python environment manager, install it there. Otherwise, install it with `pip`:

```bash
python3 -m pip install snakemake
```

or if you use `uv`:

```bash
uv pip install snakemake
```

To verify that this worked, run `snakemake --version`.

Now, to see the benefits of Snakemake, delete the `template/results/` directory, go to the `template` directory, run

``` bash
snakemake
```

And it will build all the necessary figures and tables, compile the document, compile the supplement, create a version for arXiv, and compile that too.
