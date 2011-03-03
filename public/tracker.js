(function () {
  try {
    var uri, key, value, visitorInfo, cookieExpiry, cookieValue, i, random,
        uuid = "",
        queryComponents = [],
        image = new Image(),
        encode = encodeURIComponent;

    visitorInfo = document.cookie.match(/snowfinch=([0-9A-Z]{8}-[0-9A-Z]{4}-4[0-9A-Z]{3}-[89AB][0-9A-Z]{3}-[0-9A-Z]{12})/);

    if (visitorInfo == null) {
      for (i = 0; i < 32; i++) {
        random = Math.random() * 16 | 0;

        if (i == 8 || i == 12 || i == 16 || i == 20) {
          uuid += "-"
        }
        uuid += (i == 12 ? 4 : (i == 16 ? (random & 3 | 8) : random)).
          toString(16);
      }

      snowfinch.uuid = uuid;

      cookieExpiryDate = new Date();
      cookieExpiryDate.setDate(cookieExpiryDate.getDate() + 7305);
      cookieValue = snowfinch.uuid +
        "; expires=" + cookieExpiryDate.toUTCString();
      document.cookie = "snowfinch=" + cookieValue;
    }
    else {
      snowfinch.uuid = visitorInfo[1];
    }

    snowfinch.uri = window.location.href;
    snowfinch.referrer = document.referrer;

    for (key in snowfinch) {
      if (!snowfinch.hasOwnProperty(key)) { continue }
      value = snowfinch[key];
      if (key === "collector") {
        uri = value;
      }
      else {
        queryComponents.push(encode(key) + "=" + encode(value));
      }
    }

    uri += "?" + queryComponents.join("&");
    image.src = uri;
  }
  catch(err) {}
})();
