#!/usr/lib/jvm/java-1.8.0/bin/jjs

var files = Packages.java.nio.file.Files;
var paths = Packages.java.nio.file.Paths;
var system = Packages.java.lang.System;
var utf8 = Packages.java.nio.charset.StandardCharsets.UTF_8;
var replace = Packages.java.nio.file.StandardCopyOption.REPLACE_EXISTING;

function generateFile(inFile, outFile) {
    var input = files.newBufferedReader(paths.get(inFile), utf8);
    var output = files.newBufferedWriter(paths.get(outFile), utf8);
    var passing = true;
    var pending = "";
    var ender = "";
    for (;;) {
        var line = input.readLine();
        if (null === line) {
            break;
        }
        if (passing) {
            if (/^\s*\/\*\*\s*$/.test(line)) {
                output.write(pending);
                pending = "";
                output.write("\n");
                output.write(line);
                output.write("\n");
                passing = false;
            }
        } else {
            if (/^\s*\*\/\s*$/.test(line)) {
                passing = true;
            } else {
                // inside comments block
                var nmatch = /^\s*\*\s*@namespace\s+([a-zA-z0-9\/_]+)\s*$/.exec(line);
                if (null !== nmatch && 2 === nmatch.length) {
                    pending += ("\nnamespace " + nmatch[1] + " {\n");
                    ender += "\n}\n";
                } else {
                    var fmatch = /^\s*\*\s*@(static|function)\s+([a-zA-z0-9]+)\s*.*$/.exec(line);
                    if (null !== fmatch && (3 === fmatch.length)) {
                        var statmod = "static" === fmatch[1] ? "static" : "";
                        pending += ( fmatch[2] + "(");
                        line = "";
                    } else {
                        var pmatch = /^\s*\*\s*@param\s+([a-zA-z0-9]+)\s+`([a-zA-z0-9|]+)`.*$/.exec(line);
                        if (null !== pmatch && 3 === pmatch.length) {
                            pending += pmatch[2] + " " + pmatch[1] + ",";
                        } else {
                            var rmatch = /^\s*\*\s*@return\s+`([a-zA-z0-9]+)`\s*.*$/.exec(line);
                            if (null !== rmatch && 2 === rmatch.length) {
                                pending = statmod + " " + rmatch[1] + " " + pending;
                                if ("," === pending[pending.length - 1]) {
                                    pending = pending.substring(0, pending.length - 1);
                                }
                                pending += ");\n";
                            }
                        }
                    }
                }
            }
            if (line.length > 0) {
                output.write(line);
                output.write("\n");
            }
        }
    }
    output.write(pending);
    output.write(ender);
    input.close();
    output.close();
}

function listDirectory(dir) {
    var iter = files.newDirectoryStream(paths.get(dir));
    var list = [];
    for each (pa in iter) {
        list.push(pa);
    }
    iter.close();
    list.sort(function(a, b) {
        return a.toString().compareTo(b.toString());
    });
    return list;
}

function walkAndGenerate(inDir, outDir) {
    files.createDirectory(paths.get(outDir));
    var list = listDirectory(inDir);
    for each (pa in list) {
        var fname = pa.getFileName().toString();
        var inPath = paths.get(inDir, fname);
        var outPath = paths.get(outDir, fname);
        if (files.isDirectory(pa)) {
            if ("test" !== pa.getFileName().toString()) {
                print("  directory: [" + inPath.toString() + "]");
                walkAndGenerate(inPath.toString(), outPath.toString());
            }
        } else if (fname.endsWith(".js")) {
            print("    doxify: [" + inPath.toString() + "]");
            generateFile(inPath.toString(), outPath.toString());
        }
    }
}

walkAndGenerate(arguments[0], arguments[1]);
