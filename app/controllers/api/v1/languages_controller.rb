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
        # response = [{ id: 72, name: 'Ruby (2.7.0)', code: '# Write your code here' },
        #             { id: 49, name: 'C (GCC 8.3.0)', code: c_sampl_code },
        #             { id: 54, name: 'C++ (GCC 9.2.0)', code: c_plus_sample_code },
        #             { id: 62, name: 'Java (OpenJDK 13.0.1)', code: java_sample_code },
        #             { id: 71, name: 'Python (3.8.1)', code: '# Write your code here' },
        #             { id: 63, name: 'JavaScript (Node.js 12.14.0)', code: '// Write your code here' }]
        response = [{ id: 72, name: 'Ruby (2.7.0)', code: '# Write your code here' },
                    { id: 62, name: 'Java (OpenJDK 13.0.1)', code: java_sample_code }]
        render json: response
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
        # <<~CODE
        #   public class Main {
        #   public static void main(String[] args) {
        #     // your code goes here
        #     }
        #   }
        # CODE

        <<~CODE
          import java.util.*;

          public class Main {

            public static int[] arrayCombination(int[] arrayOne, int[] arrayTwo, int n)
            {
                // Write your logic here
            }

            public static void main(String[] args) {
              // Uncomment below lines to accept input or write your own logic

              // Scanner sc = new Scanner(System.in);
              // String line1 = sc.nextLine();
              // String line2 = sc.nextLine();
              // int n = sc.nextInt();
              // String[] array1 = line1.split(",");
              // String[] array2 = line2.split(",");
              // int[] intarrayTemp1 = Arrays.asList(array1).stream().mapToInt(Integer::parseInt).toArray();
              // int[] intarrayTemp2 = Arrays.asList(array2).stream().mapToInt(Integer::parseInt).toArray();

              // int[] finalOutput = arrayCombination(intarrayTemp1, intarrayTemp2,n);

              // System.out.println(finalOutput[0] + "," + finalOutput[1]);
            }
          }
        CODE
      end

      def show
        response = JudgeZeroApi.new(params[:id]).get('/languages')
        render json: response.to_s
      end
    end
  end
end
