import osproc, os, streams, strutils

## Importing this module will start gnuplot. Array contents are written
## to temporary files (in /tmp) and then loaded by gnuplot. The temporary
## files aren't deleted automatically.


type
  Figure = object
    gp: Process
    nplots: int

proc startGnuplot(): Figure =
  ## Initiates a new Figure that communicates with gnuplot
  let gnuplot_exe = findExe("gnuplot")
  if gnuplot_exe == "":
    raise newException(IOError, "Cannot find gnuplot: exe not in PATH")
  try:
    result.gp = startProcess(gnuplot_exe, args = ["-p"])
  except:
    echo "Error: Couldn't start " & gnuplot_exe
    raise

var gFigure = startGnuplot()

proc plotCmd(replot: bool): string =
  if gFigure.nplots != 0 and replot:
    result = "replot "
  else:
    result = "plot "

proc tmpFilename(): string =
  getTempDir() & "gnuplotnim_" & $gFigure.nplots & ".tmp"

proc cmd*(cmd: string) =
  ## Send a command to gnuplot
  echo cmd
  try:
    gFigure.gp.inputStream.writeLine cmd
    gFigure.gp.inputStream.flush
  except:
    echo "Error: Couldn't send command to gnuplot"
    raise

template plotFunctionImpl() =
  var line = plotCmd(replot) & equation
  if title != "":
    line &= " title \"" & title & "\""
  cmd(line)
  gFigure.nplots += 1

template plotDataImpl(arg, extra: typed) =
  let
    title_line =
        if title == "": " notitle"
        else: " title \"" & title & "\""
    line = plotCmd(replot) & arg & extra & title_line
  cmd(line)
  gFigure.nplots += 1

proc plot*(equation: string, title = "", replot = true) =
  ## Plot an equation as understood by gnuplot. e.g.:
  ##
  ## .. code-block:: nim
  ##   plot "sin(x)/x"
  plotFunctionImpl()

template withTemp(f, fn, mode, actions: untyped): untyped =
  let fn = tmpFilename()
  var f: File
  if open(f, fname, mode):
    try:
      actions
    finally:
      close(f)
  else:
    raise newException(IOError,
        "Cannot open temporary file: " & fn)

proc plot*[X: SomeReal](xs: openarray[X],
          title = "", replot = true) =
  ## plot an array or seq of float64 values. e.g.:
  ##
  ## .. code-block:: nim
  ##   import random, sequtils
  ##
  ##   let xs = newSeqWith(20, random(1.0))
  ##
  ##   plot xs, "random values"
  withTemp(f, fname, fmWrite):
    for x in xs:
      f.writeLine(x)
  plotDataImpl("\"" & fname & "\"", "")

proc plot*[X, Y](xs: openarray[X],
                ys: openarray[Y],
                title = "",
                replot = true) =
  ## plot points taking x and y values from corresponding pairs in
  ## the given arrays.
  ##
  ## With a bit of effort, this can be used to
  ## make date plots. e.g.:
  ##
  ## .. code-block:: nim
  ##   let
  ##       X = ["2014-01-29",
  ##            "2014-02-05",
  ##            "2014-03-15",
  ##            "2014-04-12",
  ##            "2014-05-24",
  ##            "2014-06-02",
  ##            "2014-07-07",
  ##            "2014-08-19",
  ##            "2014-09-04",
  ##            "2014-10-26",
  ##            "2014-11-21",
  ##            "2014-12-07"]
  ##       Y = newSeqWith(len(X), random(10.0))
  ##
  ##   cmd "set timefmt \"%Y-%m-%d\""
  ##   cmd "set xdata time"
  ##
  ##   plot X, Y, "somecoin value over time"
  ##
  ## or other drawings. e.g.:
  ##
  ## .. code-block:: nim
  ##   var
  ##       X = newSeq[float64](100)
  ##       Y = newSeq[float64](100)
  ##
  ##   for i in 0.. <100:
  ##       let f = float64(i)
  ##       X[i] = f * sin(f)
  ##       Y[i] = f * cos(f)
  ##
  ##   plot X, Y, "spiral"
  if xs.len != ys.len:
    raise newException(ValueError, "xs and ys must have same length")
  withTemp(f, fname, fmWrite):
    for i in xs.low..xs.high:
      f.writeLine(xs[i], " ", ys[i])
  plotDataImpl("\"" & fname & "\"", " using 1:2")

proc pdf*(filename = "tmp.pdf", width = 14, height = 9) =
  ## script to make gnuplot print into a pdf file
  ## Size is given in cm.
  ## In order to change the font edit gnuplot variable my_font in style_template.
  ##
  ## .. code-block:: nim
  ##   pdf(filename="myFigure.pdf")  # overwrites/creates myFigure.pdf
  cmd("set term push")
  cmd("set term pdfcairo enhanced size " & $width & "cm, " & $height & "cm color solid font my_font")
  cmd("set out '" & filename & "'")
  cmd("replot")
  cmd("set term pop; replot")

proc png*(filename = "tmp.png", width = 640, height = 480) =
  ## script to make gnuplot print into a png file
  ## Size is given in pixels.
  ## In order to change the font edit gnuplot variable my_font in style_template.
  ##
  ## .. code-block:: nim
  ##   pdf(filename="myFigure.png")  # overwrites/creates myFigure.png
  cmd("set term push")
  cmd("set term pngcairo enhanced size " & $width & ", " & $height & " font my_font")
  cmd("set out '" & filename & "'")
  cmd("replot")
  cmd("set term pop; replot")

addQuitProc(proc() {.noconv.} =
  # close figure at the end of the session
  cmd("exit")
  var outp = gFigure.gp.outputStream()
  discard gFigure.gp.waitForExit()
  var line = newStringOfCap(120)
  while outp.readLine(line):
    echo line
  gFigure.gp.close()
)
