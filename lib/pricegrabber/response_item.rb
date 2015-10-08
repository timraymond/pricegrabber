module PriceGrabber
  class ResponseItem
    def self.with_attributes(attrs)
      ins = new
      eigenclass = class << ins
                     self
                   end
      attrs.each do |attr|
        attr_clean = attr.tr(".", "_")
        eigenclass.instance_eval do
          define_method(attr_clean.to_sym) do
            instance_variable_get(:"@#{attr_clean}")
          end

          define_method(:"#{attr_clean}=") do |val|
            instance_variable_set(:"@#{attr_clean}", val)
          end
        end
      end
      ins
    end

    def empty?
      instance_variables.inject(true) do |is_empty, ivar_name|
        is_empty && !instance_variable_get(ivar_name)
      end
    end
  end
end
