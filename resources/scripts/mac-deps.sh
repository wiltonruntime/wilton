#!/bin/bash 
#
# Copyright 2019, alex at staticlibs.net
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

otool -L $1 | grep '.*libwilton_.*\.dylib ' | awk '{print $1}' | while read entry
do
    libname=$(basename -- $entry)
    echo install_name_tool -change $entry @executable_path/$libname $1
    install_name_tool -change $entry @executable_path/$libname $1
done

