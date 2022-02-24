describe('Home', () => {
  it('display application name', () => {
      cy.visit('/')
      cy.get('h1')
        .should('contain', 'Monitofen')
      cy.percySnapshot()
  }) 
})