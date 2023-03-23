const path = require("path");
const ForkTsCheckerWebpackPlugin = require("fork-ts-checker-webpack-plugin");
const CopyPlugin = require("copy-webpack-plugin");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");

const zlib = require("zlib");

const prefix = "nyaassets-";
const isDev = process.env.NODE_ENV !== "production";
const isProd = !isDev;

const config = (isDev) => ({
  mode: isDev ? "development" : "production",
  resolve: {
    extensions: [".js", ".ts", ".elm"],
  },
  entry: "./src/index.ts",
  output: {
    path: path.resolve(__dirname, "build"),
    filename: `nyaasets/${prefix}-[name].js`,
    publicPath: "",
  },
  devServer: {
    host: "0.0.0.0",
    hot: false,
    historyApiFallback: {
      disableDotRule: false,
    },
  },
  watch: isDev,
  watchOptions: {
    ignored: /node_modules/,
    aggregateTimeout: 300,
    poll: 500,
  },
  module: {
    rules: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: [
          {
            loader: "elm-webpack-loader",
            options: {
              cwd: __dirname,
              debug: isDev,
              optimize: isProd,
            },
          },
        ],
      },
      {
        test: /\.(ts)?$/,
        loader: "esbuild-loader",
        // exclude: [[path.resolve(__dirname, 'node_modules')]],
        options: {
          loader: "ts",
          target: "es2020",
        },
      },
      {
        test: /\.scss$/,
        use: [
          MiniCssExtractPlugin.loader,
          {
            loader: "css-loader",
            options: {},
          },
          "sass-loader",
        ],
      },
    ],
  },
  plugins: [
    new MiniCssExtractPlugin({
      filename: `nyaasets/${prefix}-style.css`,
      chunkFilename: `[name].css`,
    }),
    new HtmlWebpackPlugin({
      template: "src/index.ejs",
    }),

    new ForkTsCheckerWebpackPlugin(),
    new CopyPlugin({
      patterns: [
        {
          from: "public/**/*",
          to: `nyaasets/${prefix}-[name][ext]`,
          toType: "template",
        },
      ],
    }),
  ],
});

module.exports = (_, argv) => config(argv.mode !== "production");
