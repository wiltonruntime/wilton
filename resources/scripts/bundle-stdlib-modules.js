#!/usr/lib/jvm/java-1.8.0/bin/jjs

/*
 * Copyright 2017, alex at staticlibs.net
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

// jjs bundle-stdlib-modules.js -- path/to/modules path/to/modules_bundled

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
    ".md"
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
    for each (expath in excludes) {
        if (expath.equals(pa)) {
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
    for each (pref in filePrefixExcludes) {
        if (fname.startsWith(pref)) {
            return true;
        }
    }
    for each (post in filePostfixExcludes) {
        if (fname.endsWith(post)) {
            return true;
        }
    }
    for each (expath in excludes) {
        if (expath.equals(pa)) {
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

function walkAndCopy(inDir, outDir, modcfg, minify) {
    files.createDirectories(paths.get(outDir));
    var list = listDirectory(inDir);
    for each (pa in list) {
        var fname = pa.getFileName().toString();
        var inPath = paths.get(inDir, fname);
        var outPath = paths.get(outDir, fname);
        if (null === modcfg) { // top level dir, top level scripts are ignored
            if (files.isDirectory(pa) && !isModuleExcluded(pa)) { 
                var cfg = readConfig(pa.toString());
                if (true !== cfg.excludeModule) {
                    var collectedExcludes = [];
                    for each (en in cfg.excludes) {
                        collectedExcludes.push(paths.get(pa, en));
                    }
                    var collectedPreMin = [];
                    for each (en in cfg.preMinifiedFiles) {
                        collectedPreMin.push(paths.get(pa, en));
                    }
                    var mcfg = {
                        excludes: collectedExcludes,
                        preMinifiedFiles: collectedPreMin,
                        minify: false === cfg.minify ? false : true
                    };
                    print("module: [" + fname + "]");
                    walkAndCopy(inPath.toString(), outPath.toString(), mcfg, minify);
                }
            }
        } else {
            if (files.isDirectory(pa)) {
                if (!isDirExcluded(pa, modcfg.excludes)) {
                    // print("  directory: [" + inPath.toString() + "]");
                    walkAndCopy(inPath.toString(), outPath.toString(), modcfg, minify);
                }
            } else if (!isFileExcluded(pa, modcfg.excludes)) {
                files.copy(inPath, outPath);
            }
        }
    }
}

walkAndCopy(arguments[0], arguments[1], null);


