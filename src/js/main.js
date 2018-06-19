import mapboxgl from "mapbox-gl";

function wrapElmApplication(elmApp) {
  window.customElements.define(
    "elm-mapbox-map",
    class MapboxMap extends window.HTMLElement {
      constructor() {
        super();
        this._refreshExpiredTiles = true;
        this._renderWorldCopies = true;
        this.interactive = true;
      }

      get mapboxStyle() {
        return this._style;
      }
      set mapboxStyle(value) {
        if (this._map) this._map.setStyle(value);
        this._style = value;
      }

      get minZoom() {
        return this._minZoom;
      }
      set minZoom(value) {
        if (this._map) this._map.setMinZoom(value);
        this._minZoom = value;
      }

      get maxZoom() {
        return this._maxZoom;
      }
      set maxZoom(value) {
        if (this._map) this._map.setMaxZoom(value);
        this._maxZoom = value;
      }

      get map() {
        return this._map;
      }

      get maxBounds() {
        return this._maxBounds;
      }
      set maxBounds(value) {
        if (this._map) this._map.setBounds(value);
        this._maxBounds = value;
      }

      get renderWorldCopies() {
        return this._renderWorldCopies;
      }
      set renderWorldCopies(value) {
        if (this._map) this._map.setRenderWorldCopies(value);
        this._renderWorldCopies = value;
      }

      connectedCallback() {
        mapboxgl.accessToken = this.token;
        this.style.display = "block";
        this.style.width = "100%";
        this.style.height = "100%";
        this._map = new mapboxgl.Map({
          container: this,
          style: this._style,
          minZoom: this._minZoom || 0,
          maxZoom: this._maxZoom || 22,
          interactive: this.interactive,
          attributionControl: false,
          logoPosition: this.logoPosition || "bottom-left",
          refreshExpiredTiles: this._refreshExpiredTiles,
          maxBounds: this._maxBounds,
          center: this.center,
          // zoom: this.zoom,
          // bearing: this.bearing,
          // pitch: this.pitch,
          renderWorldCopies: this._renderWorldCopies
          // maxTileCacheSize: this._maxTileCacheSize,
          // localIdeographFamily: this._localIdeographFamily
        });
      }

      disconnectedCallback() {
        this._map.remove();
        delete this._map;
      }
    }
  );
  return elmApp;
}

export default wrapElmApplication;
