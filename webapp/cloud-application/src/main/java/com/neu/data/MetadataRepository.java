package com.neu.data;

import com.neu.pojo.Metadata;
import org.springframework.data.repository.CrudRepository;

public interface MetadataRepository extends CrudRepository<Metadata, Long> {

    public void deleteMetadataById(String id);

    public Metadata getMetadataById(String id);
}
