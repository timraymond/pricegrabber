module PriceGrabber
  class ResponseHandler < Nokogiri::XML::SAX::Document
    # @param wants [Array<String>] The attributes from the XML response that are desired by the caller
    # @param result_set [Array] Where results will be deposited as results are parsed
    def initialize(wants, result_set)
      @wants = wants
      @result_set = result_set
      @working_element = nil
      @active_element_name = nil
    end

    def characters(content)
      if @active_element_name
        @working_element[@active_element_name.to_sym] = content
      end
    end

    def start_element(name, attributes = [])
      case name
      when 'product'
        @working_element = {}
      when *@wants
        @active_element_name = name
      end
    end

    def end_element(name)
      if name == @active_element_name
        @result_set << @working_element
      elsif name == 'product'
        @working_element = nil
      end
      @active_element_name = nil
    end
  end
end
