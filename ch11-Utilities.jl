################################################################################
# Code snippets of the book:
# A. Lobianco (2019) Julia Quick Syntax Reference - A Pocket Guide for Data
# Science Programming, Apress
# https://doi.org/10.1007/978-1-4842-5190-4
# Licence: Open Domain
################################################################################

# Chapeter 11 : Utilities


# Code snippet #11.1: Creating a dynamic document

using Weave;
weave("ch11-testWeave.jmd", out_path = :pwd)  # HTML
weave("ch11-testWeave.jmd", out_path = :pwd, doctype = "pandoc2pdf") #PDF


# Code snippet #11.2: Manage zip archives

using ZipFile
zf = ZipFile.Writer("example.zip")
f1 = ZipFile.addfile(zf, "file1.txt", method=ZipFile.Deflate)
write(f1, "Hello world1!\n")
write(f1, "Hello world1 again!\n")
f2 = ZipFile.addfile(zf, "dir1/file2.txt", method=ZipFile.Deflate)
write(f2, "Hello world2!\n")
close(zf) # Important!

zf = ZipFile.Reader("example.zip");
for f in zf.files
    println("*** $(f.name) ***")
    for ln in eachline(f) # Alternative: read(f,String) to read the whole file
        println(ln)
    end
end
close(zf) # Important!


# Code snippet #11.3: Expose an interacting model on the web

using Interact,Plots,Mux
function myModel(p1,p2)
    xrange = collect(-50:+50)
    model = p1.*xrange .+ p2.* (xrange) .^2
    return model
end
function createLayout()
  p1s = slider(-50:50, label = "Par#1 (linear term):", value = 1)
  p2s = slider(-5:0.1:5, label = "Par#2 (quad term):", value = 1)
  mOutput = Interact.@map myModel(&p1s,&p2s)
  plt = Interact.@map plot(collect(-50:50),&mOutput, label="Model output")
  wdg = Widget(["p1" => p1s, "p2" => p2s], output = mOutput)
  @layout! wdg hbox(plt, vbox(:p1, :p2))
end
function serveLayout(destinationPort)
    try
      WebIO.webio_serve(page("/", req -> createLayout()), destinationPort)
    catch e
      if isa(e, IOError)
        # sleep and then try again
        sleep(0.1)
        serveLayout(destinationPort)
      else
        throw(e)
      end
    end
end
serveLayout(8001)
