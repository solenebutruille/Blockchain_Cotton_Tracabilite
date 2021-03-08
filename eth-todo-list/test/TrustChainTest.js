const TrustChain = artifacts.require('./TrustChain.sol')

contract('TrustChain', (accounts) => {
  before(async () => {
    this.trustChain = await TrustChain.deployed()
  })

  it('deploys successfully', async () => {
    const address = await this.trustChain.address
    assert.notEqual(address, 0x0)
    assert.notEqual(address, '')
    assert.notEqual(address, null)
    assert.notEqual(address, undefined)
  })

  it('lists certificates', async () => {
    //we now check the task is correct
   const certificateNumber = await this.trustChain.certificateNumber()
   const certificate = await this.trustChain.certificates(certificateNumber)
   assert.equal(certificate.id.toNumber(), certificateNumber.toNumber())
   assert.equal(certificate.chainActor, 'Farmier')
   assert.equal(certificate.auditGroup, "Groupe de Audit A")
   assert.equal(certificate.certificateType, 1)
   assert.equal(certificate.validated, true)
 })

 it('creates certificate', async () => {
    const result = await this.trustChain.createCertificate('Farmier', 'Groupe Audit A', 0, true)
    const certificateNumber = await this.trustChain.certificateNumber()
    assert.equal(certificateNumber, 2)
    const event = result.logs[0].args
    assert.equal(event.id.toNumber(), 2)
    assert.equal(event.chainActor, 'Farmier')
    assert.equal(event.auditGroup, 'Groupe Audit A')
    assert.equal(event.certificateType, 0)
    assert.equal(event.validated, true)
  })

 it('return certificate for a  chain actor', async () => {
     //we now check the task is correct
    const certificateNumber = await this.trustChain.certificateNumber()
    const certificate = await this.trustChain.certificates(1)
    const result = await this.trustChain.returnCertificatesChainActor(certificate.chainActor)
//    console.log(result)
    assert.equal(result[0].id, 2)
    assert.equal(result[0].chainActor, 'Farmier')
    assert.equal(result[0].auditGroup, "Groupe de Audit A")
    assert.equal(result[0].certificateType, 1)
    assert.equal(result[0].validated, true)
  })

   it('return certificate for a  chain actor 3', async () => {
       //we now check the task is correct
      const certificateNumber = await this.trustChain.certificateNumber()
      const certificate = await this.trustChain.certificates(2)
      const result = await this.trustChain.returnCertificatesChainActor3(certificate.chainActor)
      console.log("resultat", result)
    })

})
