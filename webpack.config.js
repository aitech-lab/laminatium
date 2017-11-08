module.exports = {
    entry: "./src/main.coffee",
    output: {
        path: __dirname,
        filename: "main.js",
    },
    module: {
        loaders: [
            { test: /\.coffee$/, use: ["coffee-loader"] }
        ]
    }
};