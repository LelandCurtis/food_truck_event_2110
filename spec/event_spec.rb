require './event'

describe Event do
  before(:each) do
    @item1 = Item.new({name: 'Peach Pie (Slice)', price: "$3.75"})
    @item2 = Item.new({name: 'Apple Pie (Slice)', price: '$2.50'})
    @item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    @item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})

    @food_truck1 = FoodTruck.new("Rocky Mountain Pies")
    @food_truck2 = FoodTruck.new("Ba-Nom-a-Nom")
    @food_truck3 = FoodTruck.new("Palisade Peach Shack")

    @event = Event.new("South Pearl Street Farmers Market")

    @food_truck1.stock(@item1, 35)
    @food_truck1.stock(@item2, 7)
    @food_truck2.stock(@item4, 50)
    @food_truck2.stock(@item3, 25)
    @food_truck3.stock(@item1, 65)



  end
  describe 'initialize' do
    it 'exists' do
      expect(@event).to be_a(Event)
    end
    it 'has_attributes' do
      expect(@event.name).to eq("South Pearl Street Farmers Market")
      expect(@event.food_trucks).to eq([])
    end
  end

  describe 'methods' do

    describe ' #add_food_truck' do
      it 'adds a food truck to the food_trucks array' do
        expect(@event.food_trucks).to eq([])
        @event.add_food_truck(@food_truck1)
        expect(@event.food_trucks).to eq([@food_truck1])
        @event.add_food_truck(@food_truck2)
        expect(@event.food_trucks).to eq([@food_truck1, @food_truck2])
        @event.add_food_truck(@food_truck3)
        expect(@event.food_trucks).to eq([@food_truck1, @food_truck2, @food_truck3])
      end
    end

    describe ' #food_truck_names' do
      before(:each) do
        @event.add_food_truck(@food_truck1)
        @event.add_food_truck(@food_truck2)
        @event.add_food_truck(@food_truck3)
      end

      it 'returns an array' do
        expect(@event.food_truck_names).to be_a(Array)
      end

      it 'returns an array of Strings' do
        expect(@event.food_truck_names.all?{|name| name.class == String}).to eq(true)
      end

      it 'returns an Array of all the food_truck names' do
        expected = ["Ba-Nom-a-Nom", "Palisade Peach Shack", "Rocky Mountain Pies"]
        expect(@event.food_truck_names).to eq(expected)
      end
    end

    describe ' #food_trucks_that_sell' do
      before(:each) do
        @event.add_food_truck(@food_truck1)
        @event.add_food_truck(@food_truck2)
        @event.add_food_truck(@food_truck3)
      end

      it 'returns an Array' do
        expect(@event.food_trucks_that_sell(@item1)).to be_a(Array)
      end

      it 'returns an Array of FoodTrucks' do
        expect(@event.food_trucks_that_sell(@item1).all?{|food_truck|food_truck.class == FoodTruck}).to eq(true)
      end

      it 'returns correct Array' do
        expect(@event.food_trucks_that_sell(@item1)).to eq([@food_truck1, @food_truck3])
      end
    end

    describe ' #sorted_items_list' do
      before(:each) do
        @food_truck3.stock(@item3, 10)
        @event.add_food_truck(@food_truck1)
        @event.add_food_truck(@food_truck2)
        @event.add_food_truck(@food_truck3)
      end

      it 'returns an Array' do
        expect(@event.sorted_items_list).to be_a(Array)
      end

      it 'returns an Array of strings' do
        expect(@event.sorted_items_list.all?{|name| name.class == String}).to eq(true)
      end

      it 'returns expected array of names that are sorted with no duplicates' do
        expected = ["Apple Pie (Slice)", "Banana Nice Cream", "Peach Pie (Slice)", "Peach-Raspberry Nice Cream"]
        expect(@event.sorted_items_list).to eq(expected)
      end
    end

    describe ' #total_inventory' do
      before(:each) do
        @food_truck3.stock(@item3, 10)
        @event.add_food_truck(@food_truck1)
        @event.add_food_truck(@food_truck2)
        @event.add_food_truck(@food_truck3)
      end

      it 'returns a Hash' do
        expect(@event.total_inventory).to be_a(Hash)
      end

      it 'returns a Hash with items as keys' do
        expect(@event.total_inventory.keys.all?{|item| item.class == Item}).to eq(true)
      end

      it 'returns a Hash with Hashes as values' do
        expect(@event.total_inventory.values.all?{|hash| hash.class == Hash}).to eq(true)
      end

      it 'returns a sub-hash whos keys are quantity and food_trucks' do
        expect(@event.total_inventory.values.all?{|sub_hash| sub_hash.keys == [:quantity, :food_trucks]}).to eq(true)
      end

      it 'returns a sub-hash whos quantity values are integers' do
        expect(@event.total_inventory.values.all?{|sub_hash| sub_hash[:quantity].class == Integer}).to eq(true)
      end

      it 'returns a sub-hash whos food_truck values are Arrays' do
        expect(@event.total_inventory.values.all?{|sub_hash| sub_hash[:food_trucks].class == Array}).to eq(true)
      end

      it 'returns a sub-hash whos food_truck values are Arrays of FoodTrucks' do
        expect(@event.total_inventory.values.all?{|sub_hash| sub_hash[:food_trucks].all?{|food_truck|food_truck.class == FoodTruck}}).to eq(true)
      end

      it 'returns expected results' do
        expected = {"Apple Pie (Slice)" => {:quantity => 7, :food_trucks => [@food_truck1]},
                    "Banana Nice Cream" => {:quantity => 50, :food_trucks => [@food_truck2]},
                    "Peach Pie (Slice)" => {:quantity => 100, :food_trucks => [@food_truck1, @food_truck3]},
                    "Peach-Raspberry Nice Cream" => {:quantity => 50, :food_trucks => [@food_truck2]}}
      end

    end
  end
end