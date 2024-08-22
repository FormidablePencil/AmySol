import { ethers } from "hardhat";
import {parseEther} from "ethers"
import { expect } from "chai";
import { Market } from "../typechain-types";

describe("Market", async () => {
  let market: Market;
  const [owner, user1] = await ethers.getSigners();

  beforeEach(async () => {
    const MarketFactory = await ethers.getContractFactory("Market");
    market = await MarketFactory.deploy();
  });

  describe("reserve", function () {
    it("should reserve the item", async () => {
      const reserveAmount = parseEther("100");
      await market.connect(owner).reserve("Item name", { value: reserveAmount });
      expect(await market.isReserved()).to.be.true;
    });

    it("should only be callable by the owner", async () => {
      const reserveAmount = parseEther("100");
      await expect(market.connect(user1).reserve("item name", { value: reserveAmount })).to.be.revertedWith(
        "Only owner can reserve an item"
      );
    });

    it("should not allow reserving an already reserved item", async () => {
      const reserveAmount = parseEther("100");
      await market.connect(owner).reserve("item name", { value: reserveAmount });
      await expect(market.connect(owner).reserve("item name", { value: reserveAmount })).to.be.revertedWith(
        "Item is already reserved"
      );
    });
  });

  describe("cancelReservation", function () {
    it("should cancel the reservation and return the funds", async () => {
      const reserveAmount = parseEther("100");
      await market.connect(owner).reserve("item name", { value: reserveAmount });
      await market.connect(owner).cancelReservation();
      // TODO: Check that the reservation was refunded
      expect(await market.isReserved()).to.be.false;
    });

    it("should only be callable by the owner", async () => {
      await expect(market.connect(user1).cancelReservation()).to.be.revertedWith(
        "Only the owner can call this function"
      );
    });

    it("should not allow canceling a non-reserved item", async () => {
      await expect(market.connect(owner).cancelReservation()).to.be.revertedWith(
        "Item is not reserved"
      );
    });
  });

  describe("getBalance", function () {
    it("should return the contract balance", async () => {
      const depositAmount = parseEther("500");
      await market.connect(owner).reserve("item name", { value: depositAmount });
      expect(await market.balance()).to.equal(depositAmount);
    });
  });
});