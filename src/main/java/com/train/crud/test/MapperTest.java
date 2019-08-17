package com.train.crud.test;

import com.train.crud.bean.Department;
import com.train.crud.bean.DepartmentExample;
import com.train.crud.bean.Employee;
import com.train.crud.dao.DepartmentMapper;
import com.train.crud.dao.EmployeeMapper;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class MapperTest {
    @Autowired
    DepartmentMapper departmentMapper;

    @Autowired
    EmployeeMapper employeeMapper;

    @Autowired
    SqlSession sqlSession;
    @Test
    public void testCRUD(){
//        //创建springIoC容器
//        ApplicationContext ioc = new ClassPathXmlApplicationContext("applicationContext.xml");
//        //从容器中获取mapper
//        DepartmentMapper bean = ioc.getBean(DepartmentMapper.class);
//        System.out.println(departmentMapper);
//        测试部门插入
//        departmentMapper.insertSelective(new Department(null,"艾欧尼亚"));
//        departmentMapper.insertSelective(new Department(null,"雷瑟守备"));
          //测试员工插入
//        employeeMapper.insertSelective(new Employee(null,"诺手","M","nuoshou@qq.com",3));
//        employeeMapper.insertSelective(new Employee(null,"光辉女郎","f","guanghuinvlang@qq.com",4));
          //测试批量插入
        EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
        for(int i=0;i<100;i++){
            if(i % 3 == 0){
            mapper.insertSelective(new Employee(null,"寒冰","F","hanbing@qq.com",3));
            }else if (i % 3 == 1){
                mapper.insertSelective(new Employee(null,"剑圣","M","jiansheng@qq.com",4));
            }else {
                mapper.insertSelective(new Employee(null,"婕拉","F","jiela@qq.com",4));
            }
        }
    }
}
