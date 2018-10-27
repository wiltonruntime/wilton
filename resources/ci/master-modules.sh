#!/bin/bash
#
# Copyright 2018, alex at staticlibs.net
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

set -e
set -x

echo core >> repos.list
echo jni >> repos.list
echo `ls ./engines` >> repos.list
echo `ls ./modules` >> repos.list

for repo in `cat ./repos.list` ; do
    count=`ls $repo | wc -l`
    if [ "x0" != "xcount" ] ; then
        pushd $repo
        git checkout master
        git pull --quiet
        popd
    fi
done
