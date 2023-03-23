const express = require("express");
const expressStaticGzip = require("express-static-gzip");
const PORT = process.env.PORT || 8080;
const history = require("connect-history-api-fallback");
const { resolve } = require("path");
const app = express();

const publicPath = resolve(__dirname, "build");
const staticServe = expressStaticGzip(publicPath, {
  enableBrotli: false,
  orderPreference: ["br"],
  serveStatic: {
    maxAge: "1y",
    etag: false,
  },
});

app.get("/healthz", (req, res) => {
  res.send("It's alive!");
});

// First call is for requests directly to build artifacts
app.use(staticServe);

// Then we route all other requests to the SPA index.html
app.use(history({ disableDotRule: false, verbose: true }));

// Second call to the middleware is needed to catch requests from disableDotRule
app.use(staticServe);

app.listen(PORT, "0.0.0.0", () =>
  console.log(`storm-pages listening on port http://localhost:${PORT}`)
);
