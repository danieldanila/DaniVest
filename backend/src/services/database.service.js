import { Database } from "../models/index.js";

const service = {
  sync: async () => {
    await Database.sync({ force: true });
  },
};

export default service;