import express from 'express'
import puppeteer from 'puppeteer'
import redis from 'redis'
const app = express();
app.get('[^\.]+?', loadUrl);
const RENDER_CACHE = redis.createClient(); 
async function loadUrl(req, res) {
  const cache_url = 'https://{app}' + req.path;
  const url = 'https://{app}' + req.originalUrl;
  var html;
  if('{updatekey}All' in req.query) {
    RENDER_CACHE.flushall();
  }
  RENDER_CACHE.get(cache_url, async (err, data) => { 
    if(data && !('{updatekey}' in req.query)) {
      res.send(data)
    } else {
      const browser = await puppeteer.launch();
      const page = await browser.newPage();
      await page.goto(url, {waitUntil: "networkidle2"});
      await page.waitFor(2000);
      html = await page.evaluate(() => {return document.documentElement.innerHTML;});
      RENDER_CACHE.set(cache_url, html)
      res.send(html);
    }
  })  
}
app.listen({port}, () => console.log('Server started. Press Ctrl+C to quit'));