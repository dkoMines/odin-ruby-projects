# spec/connect_four_spec.rb

require './connect_four.rb'



describe Game do
  context 'when you start a game' do
    let(:game) { Game.new }
    it 'is 6 high' do
      expect(game.board.length).to be 6
    end
    it 'is 7 wide' do
      expect(game.board.all? { |row| row.length==7 }).to be true
    end
    it 'all tokens are nil' do
      expect(game.board.all? { |row| row.all? { |slot| slot == '_' }}).to be true
    end
  end
  context 'placing a token works' do
    let(:game) { Game.new }
    it 'a token can be placed' do
      expect(game.place(4, '1')).to change { game.board.last[3] }.to '1'
    end
  end
  context 'placing a token works' do
    it 'Check Win works' do
      game.place(1, '1')
      game.place(2, '1')
      game.place(3, '1')
      game.place(4, '1')
      expect(game.check_win()).to be '1'
    end
  end
end
