import express from "express";

// Create express app
const app = express();

// Set up all middlewares
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

// Healthcheck Handler
app.get("/health", async (req, res) => {
  res.sendStatus(200);
});

app.get("/version", async (req, res) => {
  res.status(200).json({ version: process.env.APP_VERSION });
})

app.get("/", async (req, res) => {
  try {
    let data = { message: "Hello World API" };
    res.status(200).json(data);
  } catch (err) {
    console.error(err);
    res
      .status(500)
      .json({ message: "The item does not exist" });
  }
});

// Get port from environment and store in Express
app.set("port", process.env.PORT || 3000);

export default app;
