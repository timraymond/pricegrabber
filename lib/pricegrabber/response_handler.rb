module PriceGrabber
  class ResponseHandler < Nokogiri::XML::SAX::Document
    # @param wants [Array<String>] The attributes from the XML response that are desired by the caller
    # @param result_set [Array] Where results will be deposited as results are parsed
    def initialize(wants, result_set)
      @wants = wants || []
      @result_set = result_set
      @meta_wants = ['error']
      @total_wants = @meta_wants | @wants
      @meta = {}

      # Scratchpad state
      @working_element = {}
      @active_element_name = nil
    end

    def characters(content)
      if @total_wants.include?(@active_element_name)
        @working_element[@active_element_name.to_sym] = content
      end
    end

    def start_element(name, attributes = [])
      @active_element_name = name
      if name == 'product'
        @working_element = {}
      end
    end

    def end_element(name)
      if @wants.include?(name)
        @result_set << @working_element
      elsif @meta_wants.include?(name)
        @meta.merge!(@working_element)
      elsif name == 'product'
        @working_element = nil
      end
      @active_element_name = nil
    end

    def end_document
      if error_msg = @meta[:error]
        fail APIError, error_msg
      end
    end
  end
end
