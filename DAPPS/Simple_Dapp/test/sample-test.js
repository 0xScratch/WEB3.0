const { expect } = require("chai");
const { ethers } = require("hardhat");
// const provider = waffle.provider;

describe("Greeting", function (){
    it('checking whether greeting works or not', async function(){
        let greet, greeting
        const [owner] = await ethers.getSigners()

        const Greeter = await ethers.getContractFactory("Greeter")
        greet = await Greeter.deploy("Hello, world")

        // greet function works
        greeting = await greet.connect(owner).greet() 
        expect(await greeting).to.eq("Hello, world")

        // setGreeting function works
        greeting = await greet.connect(owner).setGreeting("Namaste")
        expect(await greet.connect(owner).greet()).to.eq("Namaste")
    })

    it('Should recieve and store ether', async function() {
        let greet
        const [owner] = await ethers.getSigners()

        const Greeter = await ethers.getContractFactory("Greeter")
        greet = await Greeter.deploy("Hello, world")

        await greet.connect(owner).deposit({value: 10})

        expect(await greet.balance()).to.eq(10)
    })    
})
