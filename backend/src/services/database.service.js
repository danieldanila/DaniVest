import { database } from "../models/index.js";

const service = {
  sync: async () => {
    await database.bankApplicationDatabase.sync({ force: true });
  },
};

export default service;