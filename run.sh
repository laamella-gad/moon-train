#!/usr/bin/env bash

64tass src/moontrain.asm -o out/moontrain.prg --list=out/moontrain.lst --ascii

if [ $? -eq 0 ]
then
	/usr/bin/x64 out/moontrain.prg
fi