package com.mhmp.service;

import com.mhmp.dto.PasswordUpdateDTO;
import com.mhmp.dto.ProfileUpdateDTO;
import com.mhmp.vo.ProfileVO;

public interface ProfileService {

    ProfileVO getProfile();

    void updateProfile(ProfileUpdateDTO updateDTO);

    void updatePassword(String token, PasswordUpdateDTO updateDTO);
}
