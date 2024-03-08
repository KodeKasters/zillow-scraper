const puppeteer = require("puppeteer");
const zillow = require("./config/zillow.json");
const buildUrlFromQueryParams = require("./src/util/build-url.js");
require("dotenv").config();

const scrape = async () => {
  const browser = await puppeteer.launch({
    args: [
      "--disable-setuid-sandbox",
      "--no-sandbox",
      "--single-process",
      "--no-zygote",
    ],
    executablePath:
      process.env.NODE_ENV === "production"
        ? process.env.PUPPETEER_EXECUTABLE_PATH
        : puppeteer.executablePath(),
  });

  try {
    const page = await browser.newPage();
    const url = buildUrlFromQueryParams(zillow);
    //await page.goto(url);
    console.log(url);
  } catch (err) {
    console.error(err);
    process.exit(1);
  } finally {
    browser.close();
  }
};

module.exports = scrape;
