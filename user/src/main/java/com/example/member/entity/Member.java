package com.example.member.entity;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.Data;

@Data
@Entity
@Table(name="member")
public class Member {
	@Id
	private String id;
	private String password;
	private String name;
	private String zipcode;
	private String address1;
	private String address2;
	
	
}
