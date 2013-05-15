Gmaps.map.infobox = function(boxText) {
  return {
    content: boxText,
    disableAutoPan: true,
    maxWidth: 0,
    pixelOffset: new google.maps.Size(-140.28, -1),
    zIndex: null,
    boxStyle: {
      background: "url('/assets/gmaps4rails/tipbox.gif') no-repeat",
      opacity: 0.96,
      width: '310px'
    },
    closeBoxMargin: '14px 6px 2px 2px',
    closeBoxURL: '/assets/gmaps4rails/close.gif',
    infoBoxClearance: new google.maps.Size(1, 1),
    isHidden: false,
    pane: 'floatPane',
    enableEventPropagation: false
  }
};