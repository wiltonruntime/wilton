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

requireConfig = function(wiltondir, appdir) {
    // load RequireJS library
    load(appdir  + "init/compat.js");
    load(wiltondir + "js/wilton-requirejs/require.js");

    // allow RequireJS to load scripts through Rhino
    // see: https://github.com/requirejs/r.js/blob/27594a409b3d37427ec33bdc151ae8a9f67d6b2b/build/jslib/rhino.js
    require.load = function(context, moduleName, url) {
        load(url);
        //Support anonymous modules.
        context.completeLoad(moduleName);
    };

    // apply RequireJS config
    requirejs.config({
        waitSeconds: 0,
        enforceDefine: true,
        baseUrl: appdir.substring(0, appdir.length - 1)
    });

    // cleanup itself from global scope
    delete requireConfig;
};
