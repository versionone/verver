def find_or_create(asset_name, &block)
  operation = Verver::Loader::FindOrCreateOperation.new(asset_name, &block)
  order = operation.render
  api = Verver::Loader::API.new()
  result = api.lookup(order[:asset], operation.attribute_name, operation.attribute_value)
  return (if result then result else api.create(operation) end)
end

module Verver

  module Loader

    class ExecutableOperation
        def execute
          op = render()
          api = Verver::Loader::API.new()
          result = api.lookup operation_data[:asset], operation.lookup_attr, operation.lookup_value
          if result then
            return result
          else
            return api.create operation
          end
        end
    end

    class FindOrCreate < ExecutableOperation
      def initialize(asset_type, lookup_hash, data_hash)
        @asset_type = meta_friendly_name asset_type
        @lookup_attr = meta_friendly_name lookup_hash.keys.first
        @lookup_value = lookup_hash[@lookup_attr]
        @attributes = (data_hash[:attributes] or {})
        @mvrs = (data_hash[:mvrs] or {})
        @relations = (data_hash[:relations] or {})
        yield self
      end

      def render
        return {
            asset: @asset,
            find: {
                attribute: @lookup_attr,
                value: @lookup_value
                },
            data: {
                Attribute: @attributes.map do |key, value|
                    return {
                      name: key,
                      content: if key == @lookup_attr then @lookup_value else value end,
                      act: 'set'
                      }
                  end
                Relation: @relations.map do |key, value|
                    return {
                      name: key,
                      Asset: value.map {|item| {idref: item.to_s}},
                      act: 'set',
                      }
                  end,
                MVR: @mvrs.map do |key, value|
                    return {
                      name: key,
                      Asset: value.map do |item|
                        return {
                          idref: item.to_s,
                          act: 'add'
                          }
                      end
                      }
                  end
                }
            }
      end


    class FindOrCreateOperation

      include Verver::Loader::Utility

      attr_reader :asset, :attribute_name, :attribute_value

      def initialize(asset_name)
        @asset = meta_friendly_name(asset_name.to_s)
        yield self
      end

      def lookup(attribute_name, attribute_value)
        @attribute_name = meta_friendly_name(attribute_name)
        @attribute_value = attribute_value
      end

      def attributes(&block)
        @attributes ||= Attributes.new
        @attributes.append_with(&block) if block
        @attributes
      end

      def relations(&block)
        @relations ||= Relations.new
        @relations.append_with(&block) if block
        @relations
      end

      def mvrs(&block)
        @mvrs ||= Mvrs.new
        @mvrs.append_with(&block) if block
        @mvrs
      end

      def render
        create = {'Attribute'=>[], 'Relation'=>[], 'MVR' => []}

        render_attributes(attributes.collection, create['Attribute'])
        render_relations(relations.collection, create['Relation'])
        render_mvrs(mvrs.collection, create['MVR'])

        {asset: @asset, find: {attribute: @attribute_name, value: @attribute_value}, data: create}
      end

      private

      def render_attributes(collection, payload)
        meta_friendly_lookup = meta_friendly_name(@attribute_name)

        collection.each do |key, value|
          set_value = (key == meta_friendly_lookup) ? @attribute_value : value
          attribute = {'name' => key, 'content' => set_value, 'act' => 'set'}
          payload << attribute
        end
      end

      def render_relations(collection, payload)
        collection.each do |key, value|
          relation = {'name' => key, 'act' => 'set', 'Asset' => [] }
          value.each do |item|
            relation['Asset'] << {'idref' => item.to_s}
          end
          payload << relation
        end
      end

      def render_mvrs(collection, payload)
        collection.each do |key, value|
          mvr = {'name' => key, 'Asset' => [] }
          value.each do |item|
            mvr['Asset'] << {'idref' => item.to_s, 'act' => 'add'}
          end
          payload << mvr
        end
      end

    end

    class AssetDescriptor

      include Verver::Loader::Utility
      attr_reader :collection

      def initialize
        @collection ||= {}
      end

      def append_with
        yield self
        self
      end

    end

    class Attributes < AssetDescriptor

      def method_missing(name, *args, &block)
        @collection[meta_friendly_name(name)] = args[0]
      end

    end

    class Relations < AssetDescriptor

      def method_missing(name, *args, &block)
        relation_array = [] | args
        @collection[meta_friendly_name(name)] = relation_array
      end

    end

    class Mvrs < AssetDescriptor

      def method_missing(name, *args, &block)
        mvr_array = [] | args
        @collection[meta_friendly_name(name)] = mvr_array
      end

    end

  end
end
