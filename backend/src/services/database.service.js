import { Database } from "../models/index.js";

const service = {
  sync: async () => {
    await Database.sync({ alter: true });
  },
};

export default service;