module Ask
  module Monitoring
    # Pricing model for LLM API calls.
    #
    # Knows pricing per 1K tokens for common models from OpenAI, Anthropic,
    # Google, and Mistral. Users can add custom pricing.
    #
    # @example
    #   Ask::Monitoring::Cost.for("openai/gpt-4", tokens: { input: 100, output: 50 })
    #   # => 0.0035
    #
    #   Ask::Monitoring::Cost.for("anthropic/claude-3-opus", tokens: { input: 200, output: 100 })
    #   # => 0.0105
    class Cost
      # Pricing per 1K tokens in USD.
      # Format: "provider/model" => { input: price_per_1k_input, output: price_per_1k_output }
      PRICING = {
        # OpenAI
        "openai/gpt-4o"              => { input: 0.0025, output: 0.01 },
        "openai/gpt-4o-mini"         => { input: 0.00015, output: 0.0006 },
        "openai/gpt-4-turbo"         => { input: 0.01, output: 0.03 },
        "openai/gpt-4"               => { input: 0.03, output: 0.06 },
        "openai/gpt-4-32k"           => { input: 0.06, output: 0.12 },
        "openai/gpt-3.5-turbo"       => { input: 0.0005, output: 0.0015 },
        "openai/o1-preview"          => { input: 0.015, output: 0.06 },
        "openai/o1-mini"             => { input: 0.003, output: 0.012 },

        # Anthropic
        "anthropic/claude-3-opus"    => { input: 0.015, output: 0.075 },
        "anthropic/claude-3-sonnet"  => { input: 0.003, output: 0.015 },
        "anthropic/claude-3-haiku"   => { input: 0.00025, output: 0.00125 },
        "anthropic/claude-3.5-sonnet" => { input: 0.003, output: 0.015 },

        # Google
        "google/gemini-1.5-pro"      => { input: 0.00125, output: 0.005 },
        "google/gemini-1.5-flash"    => { input: 0.000075, output: 0.0003 },
        "google/gemini-1.0-pro"      => { input: 0.0005, output: 0.0015 },

        # Mistral
        "mistral/mistral-large"      => { input: 0.002, output: 0.006 },
        "mistral/mistral-medium"     => { input: 0.0027, output: 0.0081 },
        "mistral/mistral-small"      => { input: 0.001, output: 0.003 },

        # Cohere
        "cohere/command-r-plus"      => { input: 0.003, output: 0.015 },
        "cohere/command-r"           => { input: 0.0005, output: 0.0015 },

        # Amazon Bedrock / custom
        "bedrock/claude-3-sonnet"    => { input: 0.003, output: 0.015 },
        "bedrock/claude-3-haiku"     => { input: 0.00025, output: 0.00125 },
      }.freeze

      # @!attribute [rw] custom_pricing
      #   Optional user-defined pricing that extends or overrides the built-in
      #   PRICING hash. Same format: "provider/model" => { input: ..., output: ... }
      #   @return [Hash<String, Hash>]
      @custom_pricing = {}

      class << self
        attr_accessor :custom_pricing

        # Calculate the cost of an LLM call.
        #
        # @param model [String] The model identifier (e.g. "openai/gpt-4")
        # @param tokens [Hash] Token counts: { input: Integer, output: Integer }
        # @return [Float] Cost in USD (0.0 if model is unknown)
        def for(model, tokens:)
          pricing = all_pricing[model]
          return 0.0 unless pricing

          input_tokens  = (tokens[:input] || 0).to_f
          output_tokens = (tokens[:output] || 0).to_f

          (input_tokens / 1000.0 * pricing[:input]) +
            (output_tokens / 1000.0 * pricing[:output])
        end

        # Register or override pricing for a model.
        #
        # @param model [String] Model identifier
        # @param input [Float] Price per 1K input tokens
        # @param output [Float] Price per 1K output tokens
        def register(model, input:, output:)
          @custom_pricing[model] = { input: input, output: output }
        end

        private

        def all_pricing
          PRICING.merge(@custom_pricing)
        end
      end
    end
  end
end
