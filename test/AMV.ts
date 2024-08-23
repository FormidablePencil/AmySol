import { ethers } from "hardhat";
import { expect } from "chai";
import { AMV } from "../typechain-types";

enum ContentAccessLvl {
    Admin = 0, Editor = 1, ViewOnly = 2
}

describe("AMV", async () => {
  let amv: AMV;
  const [owner, user1, user2, user3] = await ethers.getSigners();
  let authorizedAddreses: AMV.AuthorizedAddressStruct[];

  function compareAuthorizedAddreses(p0: AMV.AuthorizedAddressStructOutput[]) {
    expect(p0.length).to.equal(authorizedAddreses.length);

    for (let i = 0; i < p0.length; i++) {
      expect(p0[i].addressVal).to.equal(authorizedAddreses[i].addressVal);
      expect(p0[i].contentAccessLvl).to.equal(authorizedAddreses[i].contentAccessLvl);
    }
  }

  beforeEach(async () => {
    authorizedAddreses = [
      { addressVal: owner, contentAccessLvl: ContentAccessLvl.Admin },
      { addressVal: user2, contentAccessLvl: ContentAccessLvl.Editor }
    ]


    const AMVFactory = await ethers.getContractFactory("AMV");
    amv = await AMVFactory.deploy();
    // await amv.deployed();
  });

  // describe("setPublicIPFSHash", function () {
    // it("should set the public IPFS hash", async () => {
    //   const hash = "QmbWqxBEKC3P8tqsKc98xmWNzrzDtRLMiMPL8wBuTGsMnR";
    //   await amv.connect(owner).setPublicIPFSHash(hash);
    //   expect(await amv.publicIPFSHash()).to.equal(hash);
    // });

    // it("should only be callable by the owner", async () => {
    //   const hash = "QmbWqxBEKC3P8tqsKc98xmWNzrzDtRLMiMPL8wBuTGsMnR";
    //   await expect(amv.connect(user1).setPublicIPFSHash(hash)).to.be.revertedWith(
    //     "Only the owner can call this function"
    //   );
    // });
  // });

  describe("setPrivateIPFSHash", function () {
    it("should return the private IPFS hashes for the given authorized address", async () => {
      const hash1 = "QmZULkVbpcv5j7n2keV2B92z2u1P3h9K9Fo91Y7s5zXw1";
      const hash2 = "QmbWqxBEKC3P8tqsKc98xmWNzrzDtRLMiMPL8wBuTGsMnR";
      await amv.connect(owner).setPrivateIPFSHash(hash1, authorizedAddreses);
      await amv.connect(owner).setPrivateIPFSHash(hash2, authorizedAddreses);

      expect(await amv.getPrivateIPFSHash()).to.deep.equal([[hash1], [hash2]]);
    });

    // TODO: There is authenticated addresses and there is visible and editable content

    it("should set the private IPFS hash and authorize access", async () => {
      const hash = "QmZULkVbpcv5j7n2keV2B92z2u1P3h9K9Fo91Y7s5zXw1";
      await amv.connect(owner).setPrivateIPFSHash(hash, authorizedAddreses);
      compareAuthorizedAddreses(await amv.getAllPrivilegedAddressesToIPFSHashes(hash));
    });

    it("should revert if msg.sender is unauthorized to set ipfs hash private", async () => {
      // simply validate that msg.sender is in privateIPFSHashesToAddresses
      // Todo: add owner's address to the array of items
      authorizedAddreses = [
          { addressVal: user1.address, contentAccessLvl: ContentAccessLvl.Admin },
          { addressVal: user2.address, contentAccessLvl: ContentAccessLvl.Editor }
      ]
      const hash = "QmZULkVbpcv5j7n2keV2B92z2u1P3h9K9Fo91Y7s5zXw1";
      await amv.connect(user3).setPrivateIPFSHash(hash, authorizedAddreses);

      await expect(amv.getAllPrivilegedAddressesToIPFSHashes(hash)).to.be.revertedWith(
        "Unauthorized address"
      );
    });
  });

  describe("getAllPrivilegedAddressesToIPFSHashes", function () {
    it("should fail if sender is not authorized", async () => {
      authorizedAddreses = [
          { addressVal: user1.address, contentAccessLvl: ContentAccessLvl.Admin },
          { addressVal: user2.address, contentAccessLvl: ContentAccessLvl.Editor }
      ]
      const hash = "QmZULkVbpcv5j7n2keV2B92z2u1P3h9K9Fo91Y7s5zXw1";
      await amv.connect(owner).setPrivateIPFSHash(hash, authorizedAddreses);
      await expect(amv.getAllPrivilegedAddressesToIPFSHashes(hash)).to.be.revertedWith(
        "Unauthorized address"
      );
    });

    it("should return the authorized addresses for the given private IPFS hash", async () => {
      const hash = "QmZULkVbpcv5j7n2keV2B92z2u1P3h9K9Fo91Y7s5zXw1";
      await amv.connect(owner).setPrivateIPFSHash(hash, authorizedAddreses);
      compareAuthorizedAddreses(await amv.getAllPrivilegedAddressesToIPFSHashes(hash));
    });
  
    it("should only be callable by authorized addresses of hash", async () => {
      const hash = "QmZULkVbpcv5j7n2keV2B92z2u1P3h9K9Fo91Y7s5zXw1";
      const hash2 = "1mZULkVbpcv5j7n2keV2B92z2u1P3h9K9Fo91Y7s5zXw2";
      await amv.connect(owner).setPrivateIPFSHash(hash2, authorizedAddreses);
      await expect(amv.getAllPrivilegedAddressesToIPFSHashes(hash)).to.be.revertedWith(
        "Unauthorized address"
      );
    });

    it("should only be callable by authorized unrevoked addresses", async () => {
      const hash = "QmZULkVbpcv5j7n2keV2B92z2u1P3h9K9Fo91Y7s5zXw1";
      await amv.connect(user2).setPrivateIPFSHash(hash, authorizedAddreses);
      await amv.revokeAccess(hash, [user2]);
      await expect(amv.getAllPrivilegedAddressesToIPFSHashes(hash)).to.be.revertedWith(
        "Unauthorized address"
      );
    });
  });

  describe("revokeAccess", function () {
    it("should revoke access", async () => {

    });

    it("should only be called by authorized addresses", async () => {

    });
  });

  describe("changeContentPriorityLevel", function () {
    it("should give access to authorized addresses", async () => {
      const hash = "QmZULkVbpcv5j7n2keV2B92z2u1P3h9K9Fo91Y7s5zXw1";
      await amv.connect(owner).setPrivateIPFSHash(hash, authorizedAddreses);
      compareAuthorizedAddreses(await amv.getAllPrivilegedAddressesToIPFSHashes(hash));
    });

    it("should revoke access to the private IPFS hash", async () => {
      const hash = "QmZULkVbpcv5j7n2keV2B92z2u1P3h9K9Fo91Y7s5zXw1";
      await amv.connect(owner).setPrivateIPFSHash(hash, authorizedAddreses);
      await amv.connect(owner).changeContentAccessLvl(hash, owner, ContentAccessLvl.ViewOnly);

      await expect(amv.getAllPrivilegedAddressesToIPFSHashes(hash)).to.be.revertedWith(
        "msg.sender is authorized to get all privileged addresses asssociated to ipfs hash but non were found."
      );
    });

    it("should only be callable by the owner", async () => {
      const hash = "QmZULkVbpcv5j7n2keV2B92z2u1P3h9K9Fo91Y7s5zXw1";
      await expect(amv.connect(user1).changeContentAccessLvl(
        hash, user1.address, ContentAccessLvl.ViewOnly
      )).to.be.revertedWith(
        "Only the owner can call this function"
      );
    });
  });

  describe("isAuthorized", function () {
    it("should return true if the address is authorized to access the private IPFS hash", async () => {
      const hash = "QmZULkVbpcv5j7n2keV2B92z2u1P3h9K9Fo91Y7s5zXw1";
      await amv.connect(owner).setPrivateIPFSHash(hash, authorizedAddreses);
      expect(await amv.isAuthorized(hash, owner)).to.be.true;
    });

    it("should return false if the address is not authorized to access the private IPFS hash", async () => {
      const hash = "QmZULkVbpcv5j7n2keV2B92z2u1P3h9K9Fo91Y7s5zXw1";
      await amv.connect(owner).setPrivateIPFSHash(hash, authorizedAddreses);
      expect(await amv.isAuthorized(hash, user3)).to.be.false;
    });
  });
});