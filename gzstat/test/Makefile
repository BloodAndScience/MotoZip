default:
	$(shell vessel bin)/moc $(shell vessel sources) -wasi-system-api -o mainTest.wasm mainTest.mo && wasmtime mainTest.wasm
	rm -f mainTest.wasm
