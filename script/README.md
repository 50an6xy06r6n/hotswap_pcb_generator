# KLE Conversion Script
Install dependencies:
```
npm install
```

Run script (defaults to using `layout.json` and outputs to `scad/layout.scad`):
```
npm start -- <layout json file> <optional output filename>
```


When running `npm start` for the first time, you may get this error:
```
Error: Cannot find module '.../hotswap_pcb_generator/script/node_modules/@ijprest/kle-serial/dist/index.js'. Please verify that the package.json has a valid "main" entry
```
If you see this, run `npm install` from inside the `kle-serial` directory. Tracking this issue [here](https://github.com/50an6xy06r6n/hotswap_pcb_generator/issues/1).
