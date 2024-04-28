import {
  cvToJSON,
  cvToValue,
  intCV,
  principalCV,
  stringCV,
  uintCV,
} from "@stacks/transactions";
import { describe, expect, it } from "vitest";

const accounts = simnet.getAccounts();
const address1 = accounts.get("wallet_1")!;
const address2 = accounts.get("wallet_2")!;
const address3 = accounts.get("wallet_3")!;

/*
  The test below is an example. To learn more, read the testing documentation here:
  https://docs.hiro.so/clarinet/feature-guides/test-contract-with-clarinet-sdk
*/

describe("example tests", () => {
  it("ensures simnet is well initalised", () => {
    expect(simnet.blockHeight).toBeDefined();
  });

  it("ensures can call count-up", () => {
    const { result } = simnet.callPublicFn(
      "hello-world",
      "count-up",
      [],
      address1
    );
    // expect result to be ok
    expect(result).toBeTruthy();

    // then get the counter value
    // const argument = stringCV(address1, "utf8");
    const newArgument = principalCV(address1);
    const { result: counter } = simnet.callReadOnlyFn(
      "hello-world",
      "get-count",
      [newArgument],
      address1
    );
    // expect counter to be 1
    expect(counter).toBeUint(1);
  });

  // it("shows an example", () => {
  //   const { result } = simnet.callReadOnlyFn("counter", "get-counter", [], address1);
  //   expect(result).toBeUint(0);
  // });

  // tests for my-token

  it("ensures can call transfer", () => {
    const { result: oldResult } = simnet.callPublicFn(
      "my-token",
      "transfer-from",
      [principalCV(address1), principalCV(address3), uintCV(10000)],
      address1
    );

    console.log(address1, address2, address3);
    const falseJsonResult = cvToJSON(oldResult);
    console.log(falseJsonResult);
    // expect result to be false
    expect(falseJsonResult.success).toBeFalsy();

    // const { result } = simnet.callPublicFn(
    //   "my-token",
    //   "transfer-from",
    //   [principalCV(address1), principalCV(address3), uintCV(10)],
    //   address1
    // );
    // const jsonResult = cvToJSON(result);
    // console.log(jsonResult);
    // // expect result to be false
    // expect(jsonResult.success).toBeTruthy();

    // // then get the balance of address2
    // const { result: newResult, events } = simnet.callPublicFn(
    //   "my-token",
    //   "balance-of",
    //   [principalCV(address3)],
    //   address1
    // );
    // const jsonBalance = cvToValue(newResult);
    // // expect balance to be 100 (in this form: )
    // console.log(jsonBalance);
    // console.log(events);
    // expect(jsonBalance.success).toBeTruthy();
  });
});
