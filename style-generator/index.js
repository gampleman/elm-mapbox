import { Elm } from "./src/Main.elm";
import { migrate } from "@mapbox/mapbox-gl-style-spec";
import deref from "@mapbox/mapbox-gl-style-spec/migrate/v9"
import CodeMirror from "codemirror/lib/codemirror.js";
import "codemirror/lib/codemirror.css";
import "codemirror/theme/base16-light.css";
import "codemirror/mode/elm/elm.js";
import "codemirror/mode/javascript/javascript.js";

var app = Elm.Main.init({});

customElements.define(
  "code-editor",
  class extends HTMLElement {
    constructor() {
      super();
      this._editorValue = "";
    }

    get editorValue() {
      return this._editorValue;
    }

    set editorValue(value) {
      if (this._editorValue === value) return;
      this._editorValue = value;
      if (!this._editor) return;
      this._editor.setValue(value);
    }

    get readonly() {
        return this._readonly;
    }

    set readonly(value) {
        this._readonly = value;
        if (!this._editor) return;
        this._editor.setOption('readonly', value);
    }

    get mode() {
        return this._mode;
    }

    set mode(value) {
        this._mode = value;
        if (!this._editor) return;
        this._editor.setOption('mode', value);
    }

    connectedCallback() {
      this._editor = CodeMirror(this, {
        identUnit: 4,
        mode: this._mode,
        lineNumbers: true,
        value: this._editorValue,
        readOnly: this._readonly,
        lineWrapping: true
      });

      this._editor.on("changes", () => {
        this._editorValue = this._editor.getValue();
        console.log("changes", this._editorValue)
        this.dispatchEvent(new CustomEvent("editorChanged", {detail: this._editorValue}));
      });

      const {width, height} = this.getBoundingClientRect()
      this._editor.setSize(width, height);
    }
  }
);

app.ports.requestStyleUpgrade.subscribe(style => {
    try {
        const migrated = deref(migrate(JSON.parse(style)));
        app.ports.styleUpgradeComplete.send({type: 'Ok', result: migrated});
    } catch(error) {
        app.ports.styleUpgradeComplete.send({type: 'Err', error});
    }

});
