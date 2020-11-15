/*
 * Copyright 2020, alex at staticlibs.net
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

define([], function() {
    "use strict";

    var files = Packages.java.nio.file.Files;
    var paths = Packages.java.nio.file.Paths;
    var JString = Packages.java.lang.String;
    var system = Packages.java.lang.System;
    var utf8 = Packages.java.nio.charset.StandardCharsets.UTF_8;

    var fileExcludes = {
        "bower.json": true,
        "composer.json": true,
        "Makefile": true,
        "package-lock.json": true,
        "wilton-sanity-test.js": true
    };

    var dirPrefixExcludes = [
        "."
    ];

    var filePrefixExcludes = [
        ".",
        "LICENSE",
        "LICENCE",
        "appveyor.yml"
    ];

    var filePostfixExcludes = [
        ".min.js",
        ".md",
        ".d.ts"
    ];

    function isModuleExcluded(pa) {
        var fname = pa.getFileName().toString();
        if (fname.startsWith(".")) {
            return true;
        }
        var pjpath = paths.get(pa, "package.json");
        return !files.isRegularFile(pjpath);
    }

    function isDirExcluded(pa, excludes) {
        var fname = pa.getFileName().toString();
        if (fname.startsWith(".")) {
            return true;
        }
        for (var i = 0; i < excludes.length; i++) {
            if (excludes[i].equals(pa)) {
                return true;
            }
        }
        return false;
    }

    function isFileExcluded(pa, excludes) {
        var fname = pa.getFileName().toString();
        if (true === fileExcludes[fname]) {
            return true;
        }
        for (var i = 0; i < filePrefixExcludes.length; i++) {
            var pref = filePrefixExcludes[i];
            if (fname.startsWith(pref)) {
                return true;
            }
        }
        for (var i = 0; i < filePostfixExcludes.length; i++) {
            var post = filePostfixExcludes[i];
            if (fname.endsWith(post)) {
                return true;
            }
        }
        for (var i = 0; i < excludes.length; i++) {
            if (excludes[i].equals(pa)) {
                return true;
            }
        }
        return false;
    }

    function readConfig(modpath) {
        var pjpath = paths.get(modpath, "package.json");
        var pjstr = new JString(files.readAllBytes(pjpath), utf8);
        var pj = JSON.parse(pjstr);
        if (!("object" === typeof(pj.wilton) && pj.wilton.excludes instanceof Array)) {
            throw new Error("'wilton.excludes' entry not found in package descriptor: [" + pjpath.toString() + "]");
        }
        return pj.wilton;
    }

    function listDirectory(dir) {
        var st = files.newDirectoryStream(paths.get(dir));
        var iter = st.iterator();
        var list = [];
        while (iter.hasNext()) {
            list.push(iter.next());
        }
        st.close();
        list.sort(function(a, b) {
            return a.toString().compareTo(b.toString());
        });
        return list;
    }

    function walkAndCopy(inDir, outDir, excludes) {
        files.createDirectories(paths.get(outDir));
        var list = listDirectory(inDir);
        list.forEach(function(pa) {
            var fname = pa.getFileName().toString();
            var inPath = paths.get(inDir, fname);
            var outPath = paths.get(outDir, fname);
            if (null === excludes) { // top level dir, top level scripts are ignored
                if (files.isDirectory(pa) && !isModuleExcluded(pa)) { 
                    var cfg = readConfig(pa.toString());
                    if (true !== cfg.excludeModule) {
                        var collectedExcludes = [];
                        cfg.excludes.forEach(function(en) {
                            collectedExcludes.push(paths.get(pa, en));
                        });
                        print("module: [" + fname + "]");
                        walkAndCopy(inPath.toString(), outPath.toString(), collectedExcludes);
                    }
                }
            } else {
                if (files.isDirectory(pa)) {
                    if (!isDirExcluded(pa, excludes)) {
                        // print("  directory: [" + inPath.toString() + "]");
                        walkAndCopy(inPath.toString(), outPath.toString(), excludes);
                    }
                } else if (!isFileExcluded(pa, excludes)) {
                    files.copy(inPath, outPath);
                }
            }
        });
    }

    return function(inDir, outDir) {
        walkAndCopy(inDir, outDir, null);
    };
});