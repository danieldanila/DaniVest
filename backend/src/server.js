import express from "express";
import router from "./routes/index.js";
import NotFoundError from "./errors/notFoundError.js";
import errorsHandlerWrapper from "./utils/errorsHandlers.util.js";

const app = express();

app.use(express.json());
app.use("/api", router);

app.use(errorsHandlerWrapper);

app.listen(process.env.PORT, () => {
    console.log(`The server is online and running on port ${process.env.PORT}`);
    console.log(`The server can be accessed at ${process.env.HOST}:${process.env.PORT}`)
})