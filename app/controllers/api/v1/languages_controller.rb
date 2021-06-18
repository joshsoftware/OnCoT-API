# frozen_string_literal: true

module Api
  module V1
    class LanguagesController < ApplicationController
      def index
        response = JudgeZeroApi.new.get('/languages')
        render json: response
      end

      def all
        # response = JudgeZeroApi.new.get('/languages/all')
        response = [{ id: 72, name: 'Ruby (2.7.0)', code: ruby_sample_code },
                    { id: 49, name: 'C (GCC 8.3.0)', code: c_sampl_code },
                    { id: 54, name: 'C++ (GCC 9.2.0)', code: c_plus_sample_code },
                    { id: 62, name: 'Java (OpenJDK 13.0.1)', code: java_sample_code },
                    { id: 71, name: 'Python (3.8.1)', code: '# Write your code here' },
                    { id: 63, name: 'JavaScript (Node.js 12.14.0)', code: javascript_sample_code }]
        render json: response
      end

      def ruby_sample_code
        <<~CODE
          input = gets.split(',')
          input = input.collect{|i| i.to_i} # Convert string array to integer array

          # Write your code here

          # puts output
        CODE
      end

      def c_sampl_code
        <<~CODE
          #include<stdio.h>
          int main(){
            // your code goes here
          }
        CODE
      end

      def c_plus_sample_code
        <<~CODE
          #include<iostream>
          using namespace std;
          int main(){
          // your code goes here
          }
        CODE
      end

      def java_sample_code
        <<~CODE
          public class Main {
          public static void main(String[] args) {
            // your code goes here
            }
          }
        CODE
      end

      def javascript_sample_code
        <<~CODE
          function myFunction(item, index){
              // Write your code here

              // console.log(output)
          }

          process.stdin.on('data', data => {
              // Convert string array to integer array
              var input_array = data.toString().split(',').map(i => Number(i));
              myFunction(input_array)
          })
        CODE
      end

      def show
        response = JudgeZeroApi.new(params[:id]).get('/languages')
        render json: response.to_s
      end
    end
  end
end
