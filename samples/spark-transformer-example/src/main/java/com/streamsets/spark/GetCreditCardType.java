/**
 * Copyright 2015 StreamSets Inc.
 * <p>
 * Licensed under the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 * <p>
 * http://www.apache.org/licenses/LICENSE-2.0
 * <p>
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.streamsets.spark;

import com.streamsets.pipeline.api.Field;
import com.streamsets.pipeline.api.Record;
import com.streamsets.pipeline.spark.api.SparkTransformer;
import com.streamsets.pipeline.spark.api.TransformResult;
import org.apache.spark.api.java.JavaPairRDD;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;
import org.apache.spark.api.java.function.Function;
import org.apache.spark.api.java.function.PairFlatMapFunction;
import scala.Tuple2;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

public class GetCreditCardType extends SparkTransformer implements Serializable {

  private static final String VALUE_PATH = "/credit_card";
  private static final String RESULT_PATH = "/credit_card_type";
  private HashMap<String, String[]> ccTypes = new HashMap<>();

  @Override
  public void init(JavaSparkContext javaSparkContext, List<String> params) {
    // Params are in form "MasterCard=51,52,53,54,55"
    for (String param : params) {
      // Parse the credit card type and list of prefixes
      String key = param.substring(0, param.indexOf('='));
      String prefixes[] = param.substring(param.indexOf('=') + 1, param.length()).split(",");
      ccTypes.put(key, prefixes);
    }
  }

  private static Boolean validateRecord(Record record) {
    // We need a field to operate on!
    Field field = record.get(VALUE_PATH);
    if (field == null) {
      return false;
    }

    // The field must contain a value!
    String val = field.getValueAsString();
    return val != null && val.length() > 0;
  }

  @Override
  public TransformResult transform(JavaRDD<Record> records) {
    // Validate incoming records
    JavaPairRDD<Record, String> errors = records.mapPartitionsToPair(
        new PairFlatMapFunction<Iterator<Record>, Record, String>() {
          public Iterable<Tuple2<Record, String>> call(Iterator<Record> recordIterator) throws Exception {
            List<Tuple2<Record, String>> errors = new LinkedList<>();
            // Iterate through incoming records
            while (recordIterator.hasNext()) {
              Record record = recordIterator.next();
              // Validate each record
              if (!validateRecord(record)) {
                // We have a problem - flag the record as an error
                errors.add(new Tuple2<>(record, "Credit card number is missing"));
              }
            }
            return errors;
          }
        });

    // Filter out invalid records before applying the map
    JavaRDD<Record> result = records.filter(new Function<Record, Boolean>() {
      // Only operate on valid records
      public Boolean call(Record record) throws Exception {
        return validateRecord(record);
      }
    }).map(new Function<Record, Record>() {
      public Record call(Record record) throws Exception {
        // Get the credit card number from the record
        String creditCard = record.get(VALUE_PATH).getValueAsString();

        // Look through the map of credit card types
        for (Map.Entry<String, String[]> entry : ccTypes.entrySet()) {
          // Find the first matching prefix
          for (String prefix : entry.getValue()) {
            if (creditCard.startsWith(prefix)) {
              // Set the credit card type
              record.set(RESULT_PATH, Field.create(entry.getKey()));
              return record;
            }
          }
        }

        return record;
      }
    });
    return new TransformResult(result, errors);
  }
}
