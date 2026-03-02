#!/bin/sh
haxelib run munit gen
lime test cpp
haxelib run munit test
